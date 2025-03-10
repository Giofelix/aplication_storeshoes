import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prueba/screens/login.dart'; // Importa Firestore

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddUserDialog(context); // Lógica para agregar usuario
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // User Profile Header
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  child: Icon(
                    Icons.person,
                    color: Colors.grey[600],
                    size: 60,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'User Administrator',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // User List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No users found.'));
                }

                final users = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index].data() as Map<String, dynamic>;
                    final userId = users[index].id; // ID del documento en Firestore
                    return _buildUserListItem(
                      context: context,
                      userId: userId,
                      name: user['username'],
                      role: user['role'] ?? 'User', // Campo "role" en Firestore
                      imageUrl: null,
                    );
                  },
                );
              },
            ),
          ),

          // Logout Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _logout(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  side: const BorderSide(color: Colors.blue),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build user list items
  Widget _buildUserListItem({
    required BuildContext context,
    required String userId,
    required String name,
    required String role,
    String? imageUrl,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[300],
        child: imageUrl != null
            ? Image.network(imageUrl)
            : Icon(Icons.person, color: Colors.grey[600]),
      ),
      title: Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(role),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _showEditUserDialog(context, userId, name, role); // Editar usuario
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _confirmDeleteUser(context, userId); // Eliminar usuario con confirmación
            },
          ),
        ],
      ),
    );
  }

  // Función para cerrar sesión
  void _logout(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

// Función para mostrar el diálogo de edición de usuario
void _showEditUserDialog(BuildContext context, String userId, String currentName, String currentRole) {
  // Obtener la información actual del usuario desde Firestore
  FirebaseFirestore.instance.collection('users').doc(userId).get().then((DocumentSnapshot document) {
    final userData = document.data() as Map<String, dynamic>;

    final emailController = TextEditingController(text: userData['email'] ?? '');
    final nameController = TextEditingController(text: userData['username'] ?? currentName);
    final passwordController = TextEditingController(text: userData['password'] ?? '');
    String selectedRole = userData['role'] ?? currentRole; // Valor predeterminado
    bool isPasswordVisible = false; // Estado para mostrar/ocultar contraseña

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              DropdownButtonFormField<String>(
                value: selectedRole,
                items: ['cliente', 'admin'].map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  selectedRole = newValue!;
                },
                decoration: const InputDecoration(labelText: 'Role'),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      // Cambiar el estado de visibilidad de la contraseña
                      isPasswordVisible = !isPasswordVisible;
                      // Actualizar el diálogo para reflejar el cambio
                      (context as Element).markNeedsBuild();
                    },
                  ),
                ),
                obscureText: !isPasswordVisible, // Ocultar o mostrar la contraseña
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final email = emailController.text.trim();
                final name = nameController.text.trim();
                final role = selectedRole;
                final password = passwordController.text.trim();

                // Validar el correo según el rol
                if (_validateEmailForRole(email, role)) {
                  _updateUser(userId, email, name, role, password);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        role == 'admin'
                            ? 'El correo debe terminar en @tienda.com'
                            : 'El correo no puede terminar en @tienda.com',
                      ),
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }).catchError((error) {
    print('Error al obtener los datos del usuario: $error');
  });
}

  // Función para actualizar un usuario en Firestore
  void _updateUser(String userId, String email, String newName, String newRole, String newPassword) {
    FirebaseFirestore.instance.collection('users').doc(userId).update({
      'email': email,
      'username': newName,
      'role': newRole,
      'password': newPassword,
    }).then((_) {
      print('User updated successfully');
    }).catchError((error) {
      print('Failed to update user: $error');
    });
  }

  // Función para confirmar la eliminación de un usuario
  void _confirmDeleteUser(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text('¿Estás seguro de que deseas eliminar este usuario?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _deleteUser(userId);
                Navigator.of(context).pop();
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  // Función para eliminar un usuario de Firestore
  void _deleteUser(String userId) {
    FirebaseFirestore.instance.collection('users').doc(userId).delete().then((_) {
      print('User deleted successfully');
    }).catchError((error) {
      print('Failed to delete user: $error');
    });
  }

  // Función para mostrar el diálogo de agregar usuario
  void _showAddUserDialog(BuildContext context) {
    final emailController = TextEditingController();
    final nameController = TextEditingController();
    final passwordController = TextEditingController();
    String selectedRole = 'cliente'; // Valor predeterminado

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              DropdownButtonFormField<String>(
                value: selectedRole,
                items: ['cliente', 'admin'].map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  selectedRole = newValue!;
                },
                decoration: const InputDecoration(labelText: 'Role'),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true, // Para ocultar el texto del password
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final email = emailController.text.trim();
                final name = nameController.text.trim();
                final role = selectedRole;
                final password = passwordController.text.trim();

                // Validar el correo según el rol
                if (_validateEmailForRole(email, role)) {
                  _addUser(email, name, role, password);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        role == 'admin'
                            ? 'El correo debe terminar en @tienda.com'
                            : 'El correo no puede terminar en @tienda.com',
                      ),
                    ),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Función para agregar un usuario a Firestore
  void _addUser(String email, String name, String role, String password) {
    FirebaseFirestore.instance.collection('users').add({
      'email': email,
      'username': name,
      'role': role,
      'password': password,
    }).then((_) {
      print('User added successfully');
    }).catchError((error) {
      print('Failed to add user: $error');
    });
  }

  // Función para validar el correo según el rol
  bool _validateEmailForRole(String email, String role) {
    if (role == 'admin') {
      return email.endsWith('@tienda.com');
    } else if (role == 'cliente') {
      return !email.endsWith('@tienda.com');
    }
    return false;
  }
}