# Contact Manager

- Flutter App built to manage personal contact details.

## Getting Started

- Clone this project to your local device.
- Checkout to `develop` branch.
- Run `flutter pub get` to update all dependencies.
- In the corresponding Laravel [project](https://github.com/mwanagenzi/contacts_manager_backend/tree/develop) follow the setup instructions in the README.md file.
- Copy the Laravel project's generated `ngrok` url.
- Open the file: `lib/utils/app_constants.dart` and change value of `BASE_URL` to the copied `ngrok` url.
- Open a new terminal instance in the text editor or IDE at the project's directory.
- Run `flutter run -v` to test your app.
- Open your php server application database.
- Use on of the details in the `user's` table in your MYSQL database to login. e.g email as `superuser@mail.com`  and password as `password`

## Point to note:
- Group details are updated by highlighting the contacts to remove from the group.
