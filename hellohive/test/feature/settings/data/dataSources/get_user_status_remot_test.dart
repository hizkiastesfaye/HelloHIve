import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hellohive/feature/settings/data/dataSources/user_profile_remote.dart';
import 'package:hellohive/feature/settings/data/models/user_profile_models.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_user_status_remot_test.mocks.dart';

@GenerateMocks([], customMocks: [
  MockSpec<FirebaseDatabase>(as: #MockFirebaseDatabase),
  MockSpec<FirebaseFirestore>(as: #MockFirebaseFirestore),
  MockSpec<DatabaseReference>(as: #MockDatabaseReference),
  MockSpec<DatabaseEvent>(as: #MockDatabaseEvent),
  MockSpec<DataSnapshot>(as: #MockDataSnapshot),
  MockSpec<OnDisconnect>(as: #MockOnDisconnect),
])

void main() {
  late MockFirebaseDatabase mockFirebaseDatabase;
  late MockFirebaseFirestore mockFirebaseFirestore;
  late MockDatabaseReference mockUserStatusRef;
  late MockDatabaseReference mockConnectedRef;
  late MockDatabaseEvent mockEvent;
  late MockDataSnapshot mockSnapshot;
  late UserProfileRemote userProfileRemote;
  late MockOnDisconnect mockOnDisconnect;

  setUp(() {
  mockFirebaseDatabase = MockFirebaseDatabase();
  mockFirebaseFirestore = MockFirebaseFirestore();
  mockUserStatusRef = MockDatabaseReference();
  mockConnectedRef = MockDatabaseReference();
  mockEvent = MockDatabaseEvent();
  mockSnapshot = MockDataSnapshot();
  mockOnDisconnect = MockOnDisconnect();
  userProfileRemote = UserProfileRemoteImpl(
    firebaseDatabase: mockFirebaseDatabase,
    firebaseFirestore: mockFirebaseFirestore,
  );

  // 🔴 IMPORTANT: stub .info/connected FIRST
  when(mockFirebaseDatabase.ref(".info/connected"))
      .thenReturn(mockConnectedRef);

  when(mockFirebaseDatabase.ref("status/testUser"))
      .thenReturn(mockUserStatusRef);
  });
 test(
  'should set isOnline true and register onDisconnect when connected',
  () async {
    // arrange
    const uId = 'testUser';

    final connectedEvent = MockDatabaseEvent();
    final connectedSnapshot = MockDataSnapshot();

    // Firebase refs
    when(mockFirebaseDatabase.ref('status/$uId'))
        .thenReturn(mockUserStatusRef);
    when(mockFirebaseDatabase.ref('.info/connected'))
        .thenReturn(mockConnectedRef);

    // .info/connected emits TRUE
    when(connectedSnapshot.value).thenReturn(true);
    when(connectedEvent.snapshot).thenReturn(connectedSnapshot);

    when(mockConnectedRef.onValue)
        .thenAnswer((_) => Stream.value(connectedEvent));

    // 🔑 IMPORTANT: stub userStatusRef.onValue (even if unused)
    when(mockUserStatusRef.onValue)
        .thenAnswer((_) => const Stream.empty());

    // onDisconnect
    when(mockUserStatusRef.onDisconnect())
        .thenReturn(mockOnDisconnect);

    when(mockUserStatusRef.update(any))
        .thenAnswer((_) async {});
    when(mockOnDisconnect.update(any))
        .thenAnswer((_) async {});

    // act
    userProfileRemote.getUserStatusRemote(uId);

    await Future.delayed(Duration.zero);

    // assert
    verify(
      mockUserStatusRef.update(
        argThat(containsPair('isOnline', true)),
      ),
    ).called(1);

    verify(mockUserStatusRef.onDisconnect()).called(1);

    verify(
      mockOnDisconnect.update(
        argThat(containsPair('isOnline', false)),
      ),
    ).called(1);
  },
);



}
