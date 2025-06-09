const db = require('../lib/db.js');


exports.searchFood = async(req, res) => {
    const conn = await db.init();
    try{
        const menuName = req.body.menuName;

        if (!menuName) {
            return res.status(400).json({ success: false, error: "검색할 메뉴를 입력해주세요." });
        }
        console.log('컨트롤러에서 받은 메뉴 데이터:', { menuName });
        const result = await db.query(conn, "SELECT `메뉴 이름`, `방법 분류`, `국가 분류`, `난이도 분류`, `주재료 이름`, `레시피` FROM recipes WHERE `메뉴 이름` LIKE ?",[`%${menuName}%`]);
        
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

exports.recommendFoodByIngredients = async (req, res) => {
    const conn = await db.init();
    try {
        const ingredients = req.body.ingredients; // 배열로 들어옴

        if (!Array.isArray(ingredients) || ingredients.length === 0) {
            return res.status(400).json({ success: false, error: "재료를 한 개 이상 입력해 주세요." });
        }
        console.log('추천 레시피 요청 ingredients:', ingredients);

        // AND 조건으로 모든 재료가 포함된 음식만 찾기 (예시: "계란", "양파" 모두 포함)
        // `주재료 이름` 컬럼이 "계란, 양파, ..."처럼 쉼표로 구분된 문자열이라고 가정
        let where = ingredients
            .map(ing => `\`주재료 이름\` LIKE '%${ing}%'`)
            .join(' AND ');

        const query = `
            SELECT \`메뉴 이름\`, \`방법 분류\`, \`국가 분류\`, \`난이도 분류\`, \`주재료 이름\`, \`레시피\`
            FROM recipes
            WHERE ${where}
        `;

        const result = await db.query(conn, query);

        res.status(200).json({
            success: true,
            message: "레시피 추천 성공",
            data: result
        });

    } catch (error) {
        console.error("추천 레시피 검색 중 에러:", error);
        res.status(500).json({
            success: false,
            message: "서버 오류로 추천 레시피 검색 실패",
            error: error.message
        });
    } finally {
        if (conn) await conn.end();
    }
};


exports.cosinRecommend = async (req, res) => {
    const RECOMMEND_API_URL = 'http://localhost:8000/recommend';
    const conn = await db.init();

    try {
        const { userId } = req.body;
        if (!userId) return res.status(400).json({ success: false, message: "userId 필요" });

        // 1. 좋아요 메뉴 조회
        const result = await db.query(conn,
            'SELECT recipe_name FROM recipe_likes WHERE user_id = ?', [userId]);
        const userLikes = result.map(row => row.recipe_name);
        console.log('userLikes:', userLikes);   // ★여기!

        if (!userLikes || userLikes.length === 0) {
            return res.json({ success: true, message: "좋아요 누른 레시피 없음", recommendations: [] });
        }

        // 2. FastAPI 추천 호출
        const axios = require('axios');
        const apiRes = await axios.get(RECOMMEND_API_URL, {
            params: { menus: userLikes.join(',') }
        });
        console.log('추천 API 응답:', apiRes.data); // ★여기!

        return res.json({
            success: true,
            message: "추천 레시피 TOP 10",
            recommendations: apiRes.data.recommendations
        });

    } catch (error) {
        console.error('cosinRecommend 에러:', error); // ★여기!
        return res.status(500).json({ success: false, error: error.message });
    } finally {
        if (conn) await conn.end();
    }
};
