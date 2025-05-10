const express = require('express');
const cors = require("cors");
const fs = require("fs");
const db = require("./lib/db.js");
const app = express();
const conn = db.init;
const port = 3000;

app.use(cors());
app.use(express.json()); // JSON 요청 바디 파싱

//클라이언트에서 HTTP 요청 메소드 중 GET을 이용해서 'host:port:로 요청을 보내면 실행되는 라우트
app.get('/', async(req, res) => {
    try{
        const conn = await db.init();
        const recipes = await db.query(conn, 'SELECT * FROM recipes where id < 30');
        await conn.end();
        res.json(recipes);
    } catch(err) {
        res.status(500).json({success:false, error: err.message });
    }
    
})


//app.listen() 함수를 사용해서 서버를 실행한다.
//클라이언트는 'host:port'로 노드 서버에 요청을 보낼 수 있다.
app.listen(port, ()=>{
    console.log(`서버가 http://localhost:${port} 에서 실행 중`);
})  