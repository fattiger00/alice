// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

class _$PostsService extends PostsService {
  _$PostsService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = PostsService;

  @override
  Future<Response> getPost(String id) {
    final $url = 'https://jsonplaceholder.typicode.com/posts/$id';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response> postPost(Map<String, dynamic> body) {
    final $url = 'https://jsonplaceholder.typicode.com/posts/';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response> putPost(String id, Map<String, dynamic> body) {
    final $url = 'https://jsonplaceholder.typicode.com/posts/$id';
    final $body = body;
    final $request = Request('PUT', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }
}
