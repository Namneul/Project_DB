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
            await db.close(conn);
        }
    }
};

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
            await db.close(conn);
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

        console.log('컨트롤러에서 받은 로그인 데이터:', { id });

        const users = await db.query(conn, 'SELECT id, name, password FROM users WHERE id = ?', [id]);

        if (users.length === 0) {
            return res.status(401).json({ success: false, message: '존재하지 않는 아이디입니다.' });
        }

        const user = users[0];

        if (user.password === inputPassword) {
            console.log('로그인 성공:', user.name);
            const responseData = {
                success: true,
                message: '로그인 성공',
                user: {
                    id: user.id,
                    name: user.name
                    // 여기에 JWT 토큰 등을 포함할 수 있습니다.
                }
            };
            res.json(responseData);
        } else {
            console.log('비밀번호 불일치');
            res.status(401).json({ success: false, message: '비밀번호가 일치하지 않습니다.' });
        }

    } catch (err) {
        console.error('로그인 에러:', err);
        res.status(500).json({ success: false, error: '로그인 중 서버 오류 발생', details: err.message })
    } finally{
         if (conn) {
            await db.close(conn);
        }
    }
}


exports.searchFood = async(req, res) => {
    const conn = await db.init();
    try{
        const menuName = req.body.menuName;

        if (!menuName) {
            return res.status(400).json({ success: false, error: "검색할 메뉴를 입력해주세요." });
        }
        console.log('컨트롤러에서 받은 메뉴 데이터:', { menuName });
        const result = await db.query(conn, "SELECT `메뉴 이름`, `방법 분류`, `국가 분류`, `난이도 분류`, `주재료 이름` FROM recipes WHERE `메뉴 이름` LIKE ?",[`%${menuName}%`]);
        
        if (result.length === 0) {
            return res.status(200).json({ // 404 대신 200과 함께 빈 배열을 보내는 것을 선호할 수도 있습니다.
                success: true,
                message: "검색된 음식 정보가 없습니다.",
                data: []
            });
        }

        res.status(200).json({
            success: true,
            message: "음식 검색 성공",
            data: result
        });

    } catch (error) {
        console.error("음식 검색 중 에러 발생:", error);
        res.status(500).json({
            success: false,
            message: "서버 오류로 음식 검색에 실패했습니다.",
            error: error.message
        });
    } finally {
        if (conn) {
            await conn.end();
        }
    }
}