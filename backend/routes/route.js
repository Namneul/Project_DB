const express = require('express');
const router = express.Router();
const rootController = require('../controllers/rootController.js'); // 컨트롤러 경로 수정
const userController = require('../controllers/userController.js'); // 컨트롤러 경로 수정
const searchFoodController = require('../controllers/searchController.js'); // 컨트롤러 경로 수정


// URL 경로를 /auth/register, /auth/login 등으로 하고 싶다면 app.js에서 마운트할 때 접두사를 붙입니다.
// 여기서는 이전과 동일하게 /register, /login을 사용합니다.
router.get('/', rootController.healthCheck);

router.post('/searchfood', searchFoodController.searchFood);
router.post('/register', userController.registerUser);
router.post('/login', userController.loginUser);

module.exports = router;