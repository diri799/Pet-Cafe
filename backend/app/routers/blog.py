from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session
from typing import List, Optional

from app.database import get_db
from app.models.blog import BlogPost
from app.models.user import User
from app.schemas.blog import (
    BlogPost as BlogPostSchema,
    BlogPostCreate,
    BlogPostUpdate
)
from app.routers.auth import get_current_user

router = APIRouter()


@router.get("/", response_model=List[BlogPostSchema])
async def get_blog_posts(
    skip: int = Query(0, ge=0),
    limit: int = Query(20, ge=1, le=100),
    category: Optional[str] = None,
    published_only: bool = True,
    search: Optional[str] = None,
    db: Session = Depends(get_db)
):
    """Get list of blog posts with optional filtering."""
    query = db.query(BlogPost)
    
    if published_only:
        query = query.filter(BlogPost.published == "1")
    if category:
        query = query.filter(BlogPost.category == category)
    if search:
        query = query.filter(
            BlogPost.title.ilike(f"%{search}%") | 
            BlogPost.content.ilike(f"%{search}%")
        )
    
    blog_posts = query.order_by(BlogPost.created_at.desc()).offset(skip).limit(limit).all()
    return blog_posts


@router.get("/{post_id}", response_model=BlogPostSchema)
async def get_blog_post(
    post_id: int,
    db: Session = Depends(get_db)
):
    """Get blog post by ID."""
    blog_post = db.query(BlogPost).filter(BlogPost.id == post_id).first()
    if not blog_post:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Blog post not found"
        )
    return blog_post


@router.post("/", response_model=BlogPostSchema)
async def create_blog_post(
    blog_post_data: BlogPostCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Create a new blog post."""
    # Only veterinarians and admins can create blog posts
    if current_user.role not in ["veterinarian", "shelter_admin"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only veterinarians and admins can create blog posts"
        )
    
    db_blog_post = BlogPost(
        author_id=current_user.id,
        **blog_post_data.dict()
    )
    
    db.add(db_blog_post)
    db.commit()
    db.refresh(db_blog_post)
    
    return db_blog_post


@router.put("/{post_id}", response_model=BlogPostSchema)
async def update_blog_post(
    post_id: int,
    blog_post_update: BlogPostUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Update blog post."""
    blog_post = db.query(BlogPost).filter(BlogPost.id == post_id).first()
    if not blog_post:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Blog post not found"
        )
    
    # Users can only update their own posts, admins can update any
    if blog_post.author_id != current_user.id and current_user.role != "shelter_admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not enough permissions"
        )
    
    # Update fields
    update_data = blog_post_update.dict(exclude_unset=True)
    for field, value in update_data.items():
        setattr(blog_post, field, value)
    
    db.commit()
    db.refresh(blog_post)
    return blog_post


@router.delete("/{post_id}")
async def delete_blog_post(
    post_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Delete blog post."""
    blog_post = db.query(BlogPost).filter(BlogPost.id == post_id).first()
    if not blog_post:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Blog post not found"
        )
    
    # Users can only delete their own posts, admins can delete any
    if blog_post.author_id != current_user.id and current_user.role != "shelter_admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not enough permissions"
        )
    
    db.delete(blog_post)
    db.commit()
    
    return {"message": "Blog post deleted successfully"}


@router.post("/{post_id}/like")
async def like_blog_post(
    post_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Like a blog post."""
    blog_post = db.query(BlogPost).filter(BlogPost.id == post_id).first()
    if not blog_post:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Blog post not found"
        )
    
    blog_post.likes_count += 1
    db.commit()
    
    return {"message": "Blog post liked successfully", "likes_count": blog_post.likes_count}



