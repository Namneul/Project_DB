const db = require('../lib/db.js');

exports.recipeLike = async (req, res) => {
  const conn = await db.init();


  try {
    const { userId, recipeName } = req.body;
    // 이미 좋아요 했으면 취소, 아니면 등록

    // 체크
    const [exist] = await db.query(conn, 
      "SELECT * FROM recipe_likes WHERE user_id=? AND recipe_name=?", [userId, recipeName]);

    if (exist) {
      // 좋아요 취소
      await db.query(conn, "DELETE FROM recipe_likes WHERE user_id=? AND recipe_name=?", [userId, recipeName]);
      res.json({ success: true, liked: false });
    } else {
      // 좋아요 등록
      await db.query(conn, "INSERT INTO recipe_likes (user_id, recipe_name) VALUES (?, ?)", [userId, recipeName]);
      res.json({ success: true, liked: true });
    }
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  } finally {
    if (conn) await conn.end();
  }
};

exports.recipeLikeDelete = async (req, res) => {
  const conn = await db.init();
  try {
    const userId = req.query.userId;
    const recipeName = req.query.recipeName;

    if (!userId || !recipeName) {
      return res.status(400).json({ success: false, message: "userId와 recipeName 필요" });
    }

    await db.query(conn, "DELETE FROM recipe_likes WHERE user_id=? AND recipe_name=?", [userId, recipeName]);
    res.json({ success: true, liked: false });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  } finally {
    if (conn) await conn.end();
  }
};

exports.likedRecipe = async (req, res) => {
  const conn = await db.init();


  try {
    const { userId} = req.body;

    // 체크
    if (!userId) {
      return res.status(400).json({ success: false, message: "userId 필요" });
    }

    const result = await db.query(conn,
      `SELECT r.\`메뉴 이름\`, r.\`방법 분류\`, r.\`국가 분류\`, r.\`난이도 분류\`, r.\`주재료 이름\`, r.\`레시피\`
       FROM recipes r
       JOIN recipe_likes l ON r.\`메뉴 이름\` = l.recipe_name
       WHERE l.user_id = ?`,
      [userId]
    );

      return res.status(200).json({
      success: true,
      message: "좋아요 누른 레시피 목록 출력",
      data: result
    });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  } finally {
    if (conn) await conn.end();
  }
};
