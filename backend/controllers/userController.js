const db = require('../lib/db.js');
const jwt = require('jsonwebtoken');
require('dotenv').config();


exports.registerUser = async(req, res) => {
    const conn = await db.init();
    try{
        const {name, id, password} = req.body;

         if (!name || !id || !password) {
            return res.status(400).json({ success: false, error: "이름, 아이디, 비밀번호는 필수입니다." });
        }
        console.log('컨트롤러에서 받은 회원가입 데이터:', { name, id });
        const result = await db.query(conn, 'INSERT INTO users (name, id, password) values (?, ?, ?)',[name, id, password]);
        console.log('데이터베이스 저장 결과:', result);
        
        const responseData = {
            success: true,
            message: '회원가입 완료',
            userId: result.insertId
        };
        res.status(201).json(responseData);

    } catch(err){
        console.error(err);
        if (err.code === 'ER_DUP_ENTRY') {
            res.status(409).json({ success: false, error: '이미 사용 중인 아이디입니다.' });
        } else {
            res.status(500).json({ success: false, error: '회원가입 중 서버 오류 발생', details: err.message });
        }
    } finally {
        if (conn){
            await conn.end();
        }
    }
};


exports.loginUser = async (req, res) => {
    const conn = await db.init();
    try {
        const { id, password: inputPassword } = req.body; // req.body.password를 inputPassword로 명명

        if (!id || !inputPassword) {
            return res.status(400).json({ success: false, error: "아이디와 비밀번호를 입력해주세요." });
        }

        console.log('[userController] 로그인 시도:', { id });

        const users = await db.query(conn, 'SELECT id, name, password FROM users WHERE id = ?', [id]);

        if (users.length === 0) {
            return res.status(401).json({ success: false, message: '존재하지 않는 아이디입니다.' });
        }

        const user = users[0];

        if (user.password === inputPassword) {
            console.log('[userController] 로그인 성공:', user.name);

            const secretKey = process.env.TOKEN_KEY || "secret_super_power_key";
            const tokenPayload = {userId: user.id, userName: user.name};
            const tokenOption = {expiresIn: '1h'};

            const token = jwt.sign(tokenPayload, secretKey, tokenOption);

            const responseData = {
                success: true,
                message: '로그인 성공',
                token: token,
                user: {
                    id: user.id,
                    name: user.name
                    // 여기에 JWT 토큰 등을 포함할 수 있습니다.
                }
            };
            res.json(responseData);
        } else {
            console.log('[userController] 비밀번호 불일치');
            res.status(401).json({ success: false, message: '비밀번호가 일치하지 않습니다.' });
        }

    } catch (err) {
        console.error('[userController] 로그인 에러:', err);
        res.status(500).json({ success: false, error: '로그인 중 서버 오류 발생', details: err.message })
    } finally{
        if (conn) {
            await conn.end();
        }
    }
}
