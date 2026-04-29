import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

  @override
  _LoginPageState createState()=> _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  File? _selectImage;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  
  Future<void> _login() async{
    print('-------------------++++++++++++++______________');
    print('Auth instance ready: ${_auth.app.name}');
    print('-----------++++++++++++++=================');
    print('________is ${_firestore.app.name}');
    print('-----------++++++++++++++=================');
    setState(() {
      _isLoading = true;
    _errorMessage = null;
    });

    try{
      await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(), 
          password: _passwordController.text.trim()
        );
      // Navigator.pushReplacementNamed(context, '/home');
    }
    on FirebaseAuthException catch(e){
      setState(() {
        _errorMessage = e.message ?? e.code;
      });
      
      print('Login failed: ${e.message}  -------------');
      print('Login failed: ${e.code}  -------------');
    }
    finally{
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _register() async{
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try{
      await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(), 
          password: _passwordController.text.trim()
        );
      // Navigator.pushReplacementNamed(context, '/home');
      print('Registration successful -------------');
    }
    on FirebaseAuthException catch(e){
      setState(() {
        _errorMessage = e.message ?? e.code;
      });
      print('Registration failed: ${e.message}  -------------');
      print('Registration failed: ${e.code}  -------------');
    }
    finally{
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async{
    print('before logout user is ${_auth.currentUser?.email} -------------');
    await _auth.signOut();
    print('after logout user is ${_auth.currentUser?.email} -------------');
    print('User logged out -------------');
  }

  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    print('Sending email verification to user: ${user?.email} -------------');
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<bool> isEmailVerified() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return false;

  await user.reload(); // VERY IMPORTANT
  print('-=---------------------------+++++++=----------');
  print('----++++-------${FirebaseAuth.instance.currentUser!.emailVerified}');
  return FirebaseAuth.instance.currentUser!.emailVerified;
  }
  Future<bool> checkOffline() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return false;

  print('-=---------------------------+++++++=----------');
  print('----++++-------${FirebaseAuth.instance.currentUser!.emailVerified}');
  print('-=---------------------------+++++++=----------');
  print('############# ${FirebaseAuth.instance.currentUser?.email}');
  print('-=---------------------------+++++++=----------');

  return FirebaseAuth.instance.currentUser!.emailVerified;
  
  }



  Future<void> _addUser() async{
    try{
      User? user = _auth.currentUser;
      if(user != null){
        // await user.updateDisplayName('New User');
        await user.updatePassword('1234567890');
        await user.reload();
        user = _auth.currentUser;
        print('User display name updated to: ${user?.displayName} -------------');
      } else {
        print('No user is currently signed in. -------------');
      }
    }
    on FirebaseAuthException catch(e){
      print('Failed to update user: ${e.message}  -------------');
      print('Failed to update user: ${e.code}  -------------');
    }
  }

  Future<void> _deleteUser() async{
    User? user = _auth.currentUser;
    if(user != null){
      try{
        await user.delete();
        print('User deleted successfully -------------');

      }
      on FirebaseAuthException catch(e){
        print('Failed to delete user: ${e.message}  -------------');
        print('Failed to delete user: ${e.code}  -------------');
    }
    } else {
      print('No user is currently signed in. -------------');
    }
  }

  Future<void> _addUserStore1() async{
    try{
      User? user = _auth.currentUser;
      if(user != null){
        await _firestore.collection('users').doc(user.uid).set({
          'email': user.email,
          'createdAt': FieldValue.serverTimestamp(),
        });
        print('User document added to Firestore -------------');
      } else {
        print('No user is currently signed in. -------------');
      }
    }
    on FirebaseException catch(e){
      print('Failed to add user document: ${e.message}  -------------');
      print('Failed to add user document: ${e.code}  -------------');
    }
  }
  Future<void> _addUserStore2() async{
    try{
      await _firestore.collection('users').add({
        'email': _emailController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'password': _passwordController.text.trim(),
      });
      print('User document added to Firestore -------------');
    }
    on FirebaseException catch(e){
      print('Failed to add user document: ${e.message}  -------------');
      print('Failed to add user document: ${e.code}  -------------');
    }
  }
  Future<void> _getAllUserStore() async{
    try{
      final snapShot = await _firestore.collection('users').get();
      for(var doc in snapShot.docs){
        print('User Document: ${doc.data()} -------------');
      }
    }
    on FirebaseException catch(e){
      print('Failed to get user documents: ${e.message}  -------------');
      print('Failed to get user documents: ${e.code}  -------------');
    }
  }

  Future<void> _getSingleUserStore() async{
    try{
      final doc = await _firestore.collection('users').doc('EQ8ohif0BND4FM6KHr3j').get();
      print('User Document: ${doc.data()} -------------');
    }
    on FirebaseException catch(e){
      print('Failed to get user document: ${e.message}  -------------');
      print('Failed to get user document: ${e.code}  -------------');
    }
  }
  Future<void> _updateUserStore() async{
    try{
      await _firestore.collection('users').doc('EQ8ohif0BND4FM6KHr3j').update({
        'password': 'qwertyuioop',
      });
      print('User document updated in Firestore -------------');
    }
    on FirebaseException catch(e){
      print('Failed to update user document: ${e.message}  -------------');
      print('Failed to update user document: ${e.code}  -------------');
    }
  }
  Future<void> _deleteUserStore() async{
    try{
      await _firestore.collection('users').doc('P9TtEsFkVvaqW9UrlwbH').delete();
      print('User document deleted from Firestore -------------');
    }
    on FirebaseException catch(e){
      print('Failed to delete user document: ${e.message}  -------------');
      print('Failed to delete user document: ${e.code}  -------------');
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body:SafeArea(child: 
        Center(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24),
            children: [Column(
              // padding: EdgeInsets.symmetric(horizontal: 40),
            
              children: [
                SizedBox(height: 50),
                Image.asset('assets/icons/diamond.png', scale: 10),
                SizedBox(height:15),
                Text('shrine',style: Theme.of(context).textTheme.bodyMedium),
                SizedBox(height:50),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'email',
                    hintText:'Enter your email',
                    border: OutlineInputBorder(),
                    filled:true,
                  ),
            
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    filled:true,
                    labelText: 'password'
                  ),
                  obscureText: true,
                ),
                SizedBox(height:60),
                OverflowBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: _register, 
                      child: const Text('Register')
                    ),
                    ElevatedButton(
                      onPressed:_login, 
                      child: const Text('Login'))
                  ],
                ),
                SizedBox(height:20),
                ElevatedButton(
                  onPressed:_logout, 
                  child: const Text('Logout')
                ),
                SizedBox(height:20),
                ElevatedButton(
                  onPressed:_addUser, 
                  child: const Text('Update User')
                ),
                SizedBox(height:20),
                ElevatedButton(
                  onPressed:_deleteUser, 
                  child: const Text('Delete User')
                ),
                SizedBox(height:20),
                ElevatedButton(
                  onPressed:_addUserStore1, 
                  child: const Text('Add User Store 1')
                ),
                SizedBox(height:20),
                ElevatedButton(
                  onPressed:_addUserStore2, 
                  child: const Text('Add User Store 2')
                ),
                SizedBox(height:20),
                ElevatedButton(
                  onPressed:_getAllUserStore, 
                  child: const Text('Get All User Store')
                ),
                SizedBox(height:20),
                ElevatedButton(
                  onPressed:_getSingleUserStore, 
                  child: const Text('Get Single User Store')
                ),
                SizedBox(height:20),
                ElevatedButton(
                  onPressed:_updateUserStore, 
                  child: const Text('Update User Store')
                ),
                SizedBox(height:20),
                ElevatedButton(
                  onPressed:_deleteUserStore, 
                  child: const Text('Delete User Store')
                ),
                SizedBox(height:20),
                ElevatedButton(
                  onPressed: sendEmailVerification, 
                  child: const Text('Send Email Verification')
                ),
                SizedBox(height:20),
                ElevatedButton(
                  onPressed: isEmailVerified, 
                  child: const Text('Is Email Verified')
                ),      
                SizedBox(height:20),
                ElevatedButton(
                  onPressed: checkOffline, 
                  child: const Text('checkOffline')
                ),
                SizedBox(height:20),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context,'/signup'), 
                  child: const Text('Go to Sign Up Page')
                ),               
              ],
            ),]
          )
        )
      ),
    );
  }
}