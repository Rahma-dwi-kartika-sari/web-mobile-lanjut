<?php

namespace App\Http\Middleware;

use Closure;
use Firebase\JWT\JWT;
use Firebase\JWT\Key;
use Illuminate\Http\Request;
use App\Models\User;

class JwtMiddleware
{
    public function handle(Request $request, Closure $next)
    {
        $token = $request->bearerToken();

        if (!$token) {
            return response()->json([
                'message' => 'Unauthenticated'
            ], 401);
        }

        try {
            $decoded = JWT::decode(
                $token,
                new Key(env('JWT_SECRET'), 'HS256')
            );

            $user = User::find($decoded->sub);

            if (!$user) {
                return response()->json([
                    'message' => 'Unauthenticated'
                ], 401);
            }

            $request->attributes->set('auth_user', $user);

            return $next($request);

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Token tidak valid atau sudah expired'
            ], 401);
        }
    }
}