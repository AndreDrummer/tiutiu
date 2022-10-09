import 'package:tiutiu/features/posts/models/post.dart';
import 'package:get/get.dart';

class PostsController extends GetxController {
  final RxBool _isFullAddress = false.obs;
  final Rx<Post> _post = Post().obs;
  final RxInt _flowIndex = 0.obs;

  bool get isFullAddress => _isFullAddress.value;
  int get flowIndex => _flowIndex.value;
  Post get post => _post.value;

  void set flowIndex(int index) => _flowIndex(index);

  void updatePost(PostEnum property, dynamic data) {
    final postMap = post.toMap();
    postMap[property.name] = data;

    print('>> $postMap');

    _post(Post.fromMap(postMap));
  }

  void toggleFullAddress() {
    _isFullAddress(!isFullAddress);
  }
}
