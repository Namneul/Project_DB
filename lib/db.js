const mysql = require('mysql2/promise');

const db_info = {
    host     :   'localhost',
    port     :   3306,   
    user     :   'user1',
    password :   '12345',
    database :   'recipe'
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
