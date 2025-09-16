// model/user.ts

export interface User {
    user_id:        number;
    first_name:     string | null;
    last_name:      string | null;
    email:          string;
    password_hash:  string;
    role:           'member' | 'admin';
    wallet_balance: number;
    created_at:     Date;
}