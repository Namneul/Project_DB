const db = require('../lib/db.js');


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