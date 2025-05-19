import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// TextEditingController는 Stateful 위젯 안으로 옮기는 것이 관리하기 좋습니다.
// final TextEditingController searchController = TextEditingController(); // 여기서는 제거

class SearchPage extends StatefulWidget { // StatefulWidget으로 변경
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> { // State 클래스 생성
  final TextEditingController _searchController = TextEditingController(); // State 안으로 이동
  List<dynamic>? searchResults; // 검색 결과를 저장할 변수
  bool isLoading = false; // 로딩 상태
  String? error; // 에러 메시지

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Container(
          decoration: BoxDecoration(
            color: Colors.deepOrange[300],
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _searchController, // State 안의 컨트롤러 사용
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: '검색어를 입력하세요',
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                  ),
                  onSubmitted: (value) { // 키보드에서 Enter/Done 버튼 눌렀을 때 호출
                    _searchFood();
                  },
                ),
              ),
              // 검색 버튼을 추가할 수도 있습니다.
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () { // 검색 버튼 눌렀을 때 호출
                  _searchFood();
                },
              ),
            ],
          ),
        ),
      ),
      body: Center( // 검색 결과 표시 영역
        child: isLoading
            ? const CircularProgressIndicator() // 로딩 중
            : error != null
            ? Text('Error: $error') // 에러 메시지 표시
            : searchResults == null || searchResults!.isEmpty
            ? const Text('검색어를 입력하거나 검색 결과가 없습니다.') // 초기 상태 또는 결과 없음
            : ListView.builder( // 검색 결과 목록 표시
          itemCount: searchResults!.length,
          itemBuilder: (context, index) {
            // searchResults의 각 항목은 Map<String, dynamic> 형태일 것으로 예상
            var item = searchResults![index];

            // !!! 실제 받아온 데이터의 키 이름을 사용하도록 수정 !!!
            String menuName = item['메뉴 이름'] ?? '이름 없음'; // '메뉴 이름' 사용
            // '방법 분류'와 '주재료 이름'은 배열이므로 join으로 문자열 생성
            String methodCategory = (item['방법 분류'] is List) ? (item['방법 분류'] as List).join(', ') : item['방법 분류']?.toString() ?? '분류 없음';
            String countryCategory = item['국가 분류'] ?? '국가 없음'; // '국가 분류' 사용
            String difficulty = item['난이도 분류'] ?? '난이도 없음'; // '난이도 분류' 사용
            String mainIngredients = (item['주재료 이름'] is List) ? (item['주재재료 이름'] as List).join(', ') : item['주재료 이름']?.toString() ?? '주재료 없음'; // '주재료 이름' 사용

            return ListTile(
              // 받아온 실제 데이터를 사용하여 UI 표시
              title: Text(menuName), // 메뉴 이름 표시
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('분류: $methodCategory ($countryCategory)'), // 방법 분류 및 국가 분류
                  Text('난이도: $difficulty'), // 난이도 분류
                  Text('주재료: $mainIngredients'), // 주재료 이름
                ],
              ),
              // 여기에 더 많은 정보를 표시하거나 탭 이벤트 등을 추가할 수 있습니다.
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose(); // Controller는 dispose 해줘야 메모리 누수 방지
    super.dispose();
  }

  Future<void> _searchFood() async {
    // 검색어가 비어있으면 요청하지 않음
    if (_searchController.text.isEmpty) {
      setState(() {
        searchResults = null; // 이전 검색 결과 지우기
        error = null;
      });
      return;
    }

    setState(() {
      isLoading = true; // 로딩 시작
      error = null; // 이전 에러 지우기
    });

    try {
      var url = 'http://192.168.163.1:3000/searchfood'; // Node.js API 엔드포인트 URL
      var dio = Dio();

      Map<String, dynamic> searchData = {
        'menuName': _searchController.text, // State 안의 컨트롤러 사용
      };

      print('Searching for: ${_searchController.text}');
      print('Sending data: $searchData');

      Response response = await dio.post(
        url,
        data: searchData,
      );

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}'); // 서버 응답 데이터 확인

      if (response.statusCode == 200) {
        // 서버 응답 데이터를 상태에 저장하고 UI 갱신

        // response.data는 전체 응답 객체 (Map 형태 예상)
        // 실제 데이터 배열은 response.data['data'] 에 들어있습니다.

        // 응답 데이터가 예상한 Map 형태인지 확인
        if (response.data is Map<String, dynamic>) {
          // Map 안에 'data' 키가 있고 그 값이 List 형태인지 확인
          var receivedData = response.data['data'];

          if (receivedData != null && receivedData is List) {
            setState(() {
              // searchResults에 'data' 필드의 값인 List를 할당
              // List<dynamic> 형태를 List<Map<String, dynamic>>으로 변환하는 것이 더 안전할 수 있습니다.
              // searchResults = List<Map<String, dynamic>>.from(receivedData);
              searchResults = receivedData; // 일단 dynamic 리스트로 할당
              isLoading = false;
              error = null; // 성공했으니 에러 메시지 비움
            });
            print("Data successfully loaded. Item count: ${searchResults!.length}");

          } else {
            // 'data' 필드가 없거나 List 형태가 아닐 경우
            setState(() {
              error = "Server response missing or invalid 'data' field.";
              isLoading = false;
              searchResults = null;
            });
            print("Error: Invalid 'data' field format in response: ${response.data}");
          }

        } else {
          // 응답 자체가 예상한 Map 형태가 아닐 경우
          setState(() {
            error = "Invalid response format from server.";
            isLoading = false;
            searchResults = null;
          });
          print("Error: Response is not a Map: ${response.data}");
        }

      } else {
        // 서버에서 200이 아닌 상태 코드를 보냈을 때 (예: 400, 500 등)
        // 이 경우 response.data의 구조가 에러 메시지 등을 포함할 수 있습니다.
        setState(() {
          // 500 오류처럼 서버 메시지가 있다면 response.data에서 추출하여 표시할 수도 있습니다.
          // 예: error = response.data['message'] ?? 'Failed with status code ${response.statusCode}';
          error = 'Failed to load search results. Status code: ${response.statusCode}';
          isLoading = false;
          searchResults = null; // 에러 시 결과 비움
        });
        print('Error Response Status: ${response.statusCode}');
        print('Error Response Body: ${response.data}'); // 에러 응답 본문 확인
      }

    } catch(e) { // DioException 또는 다른 예상치 못한 오류
      // 요청 중 네트워크 오류, 타임아웃 등 예외 발생 시
      print('Error during search: $e');
      setState(() {
        error = 'An error occurred: ${e.toString()}';
        isLoading = false;
        searchResults = null;
      });
    }
  }
}