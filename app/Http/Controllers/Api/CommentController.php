<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Comment;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class CommentController extends Controller
{
    public function index($productId)
    {
        $comments = Comment::with('user')
            ->where('product_id', $productId)
            ->get();
            
        return response()->json($comments);
    }

    public function store(Request $request)
    {
        $userId = Auth::id();
    
        $request->validate([
            'product_id' => 'required|integer',
            'comment_text' => 'required|string',
        ]);

        $comment = new Comment();
        $comment->user_id = $userId;
        $comment->product_id = $request->input('product_id');
        $comment->comment_text = $request->input('comment_text');
        $comment->save();

        return response()->json($comment, 201);
    }
}
