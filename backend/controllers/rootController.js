const db = require('../lib/db.js');


exports.healthCheck = async (req, res) => {
    const conn = await db.init(); // conn을 try 블록 외부에서 선언
    try {
        await db.query(conn, 'SELECT 1'); // 간단한 쿼리로 DB 응답 확인
        res.status(200).json({ success: true, message: "Server is running and DB connection is healthy." });
    } catch (err) {
        // DB 연결 또는 쿼리 실패 시
        res.status(500).json({ success: false, error: "Server is running, but database connection/query failed.", details: err.message });
    } finally {
        if (conn) {
            await conn.end();            
        }
    }
};