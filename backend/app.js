require('dotenv').config();

const express = require('express');
const cors = require("cors");
const fs = require("fs");
const bodyParser = require('body-parser');
const app = express();
const port = 3000;

const Routes = require('./routes/route');


app.use(cors());
app.use(express.json()); // JSON 요청 바디 파싱
app.use('/',Routes);
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended:true }))

app.use((req, res, next) => {
    res.status(404).json({ success: false, error: "Not Found" });
});


app.use((err, req, res, next) => {
    console.error("전역 에러 핸들러:", err.stack);
    res.status(err.status || 500).json({
        success: false,
        error: err.message || "Internal Server Error"
    });
});



//app.listen() 함수를 사용해서 서버를 실행한다.
//클라이언트는 'host:port'로 노드 서버에 요청을 보낼 수 있다.
app.listen(port, '0.0.0.0', () => {
    console.log(`서버가 http://0.0.0.0:${port} 에서 실행 중`);
});
