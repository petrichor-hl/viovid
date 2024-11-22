import 'package:viovid/main.dart';

final Map<String, dynamic> profileData = {};

Future<void> fetchProfileData() async {
  final userId = supabase.auth.currentUser!.id;
  final data = await supabase
      .from('profile')
      .select(
          'id, full_name, avatar_url, dob, my_list, password, role, thread_id')
      .eq('id', userId)
      .single();

  final subscription = await supabase
      .from('user_subscription')
      .select('start_date, end_date, plan(name)')
      .eq('user_id', data['id'])
      .order('end_date')
      .limit(1)
      .maybeSingle();

  // List.from() constructor can be used to down-cast a List
  List<String> myList = List.from(data['my_list']);

  profileData.addAll(
    {
      'user_id': data['id'],
      'password': data['password'],
      'full_name': data['full_name'],
      'dob': data['dob'],
      'avatar_url': data['avatar_url'],
      'my_list': myList,
      'role': data['role'],
      'plan': subscription?['plan']?['name'],
      'start_date': subscription?['start_date'],
      'end_date': subscription?['end_date'],
      'thread_id': data['thread_id'],
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
