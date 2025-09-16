export interface Lotto {
    lotto_id:            number;
    lotto_number:        string;
    lotto_price:         number;
    status:              'AVAILABLE' | 'SOLD' | 'CLAIMED'; // ประเภทข้อมูลที่เจาะจงมากขึ้น
    created_at:          Date;
    order_id:            number | null; // อาจจะเป็นค่าว่างได้
    prize_id:            number | null; // อาจจะเป็นค่าว่างได้
    created_by_user_id:  number | null; // อาจจะเป็นค่าว่างได้
}