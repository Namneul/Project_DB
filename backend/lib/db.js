const mysql = require('mysql2/promise');

require('dotenv').config();

const db_info = {
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME
};

module.exports = {
    // 커넥션 생성 (Promise 반환)
    init: async function() {
        try {
            const conn = await mysql.createConnection(db_info);
            console.log("mysql is connected successfully!");
            return conn;
        } catch (err) {
            console.error("mysql connection error: " + err);
            throw err;
        }
    },

    // 쿼리 실행 함수 (Promise/async-await)
    //sql은 실행할 쿼리문, params는 쿼리문의 ?에 들어갈 값. ex) sql = 'SELECT * FROM recipes WHERE name = ?', params = ['된장찌개']
    query: async function(conn, sql, params=[]) { 
        try {
            const [rows, fields] = await conn.execute(sql, params); //execute는 쿼리문 실행하는 메소드
            return rows; // 쿼리 결과만 반환
        } catch (err) {
            console.error("mysql query error: " + err);
            throw err;
        }
    }
};
