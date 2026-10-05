<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Firebase\JWT\JWT;

class AuthController extends Controller
{
    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required|min:8',
        ]);

        $user = User::where('email', $request->email)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json([
                'message' => 'Email atau password salah'
            ], 401);
        }

        $payload = [
            'sub' => $user->id,
            'name' => $user->name,
            'role' => $user->role,
            'iat' => time(),
            'exp' => time() + 3600
        ];

        $token = JWT::encode(
            $payload,
            env('JWT_SECRET'),
            'HS256'
        );

        return response()->json([
            'message' => 'Login berhasil',
            'token' => $token
        ]);
    }

    public function profile(Request $request)
    {
        $user = $request->attributes->get('auth_user');

        return response()->json([
            'data' => $user
        ]);
    }

    public function destroyUser(string $id)
    {
        $user = User::findOrFail($id);
        $user->delete();

        return response()->json([
            'message' => 'User deleted'
        ]);
    }
}