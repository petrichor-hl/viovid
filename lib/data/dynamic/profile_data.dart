import 'package:viovid/main.dart';

final profileData = {};

Future<void> fetchProfileData() async {
  final userId = supabase.auth.currentUser!.id;
  final data = await supabase
      .from('profile')
      .select('full_name, avatar_url, dob, my_list, password, role')
      .eq('id', userId)
      .single();

  // List.from() constructor can be used to down-cast a List
  List<String> myList = List.from(data['my_list']);

  profileData.addAll(
    {
      'password': data['password'],
      'full_name': data['full_name'],
      'dob': data['dob'],
      'avatar_url': data['avatar_url'],
      'my_list': myList,
      'role': data['role'],
    },
  );

  // print('My List: ${profileData['my_list']}');
}

Future<String> getRole() async {
  if (profileData.isEmpty) {
    await fetchProfileData();
  }
  return profileData['role'];
}
