const jwt = require('jsonwebtoken');

exports.authenticateToken = (req, res, next) => {
    // 1. 요청 헤더에서 Authorization 값을 가져옴
    //    'Bearer YOUR_TOKEN_HERE' 형태일 것으로 예상
    const authHeader = req.headers['authorization'];

    // 'Bearer ' 접두사 제거하고 실제 토큰만 추출
    // authHeader가 존재하면 split하고, 없으면 undefined
    const userToken = authHeader && authHeader.split(' ')[1];

    // 토큰이 없는 경우
    if (userToken == null) {
        return res.status(401).json({ message: "인증 토큰이 없습니다." });
    }

    try {
        // JWT 서명에 사용된 비밀 키 (환경 변수에서 불러옴)
        const secretKey = process.env.TOKEN_KEY || "your_super_secret_jwt_key";

        // 토큰 검증 및 디코딩
        const jwtDecoded = jwt.verify(userToken, secretKey);

        // 디코딩된 페이로드에서 userId 추출
        const userId = jwtDecoded.userId;

        // 요청 객체에 현재 사용자 ID를 추가하여 다음 미들웨어/라우터에서 사용 가능하게 함
        req.currentUserId = userId;
        console.log(`[authMiddleware] 토큰 인증 성공: userId ${userId}`);

        // 다음 미들웨어 또는 라우트 핸들러로 제어 넘김
        next();

    } catch (error) {
        console.error('[authMiddleware] JWT 인증 실패:', error.message);

        // 토큰이 유효하지 않거나 만료된 경우 403 Forbidden 응답
        // 'TokenExpiredError' 이면 '토큰 만료', 아니면 '유효하지 않은 토큰' 등으로 구체화 가능
        return res.status(403).json({ message: "유효하지 않거나 만료된 토큰입니다." });
    }
};