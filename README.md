
# RESTO
An online restaurant store front management system with 3 interfaces (User, Admin, and Delivery men).

## Installation 

1 - Clone the project.

```bash
  git clone https://github.com/K4rimCraft/Restaurant-App
```

2 - Download either the windows or the android apk releases of the app.

3 - Navigate to the backend folder.

```bash
  cd BackEnd/RESTO
```

4 - Forward Engineer the EER Schematic 'RESTO.mwb' in MYSQL.

5 - Change MYSQL_USER and MYSQL_PASS variables in the 'config.env' file to your username and password in MYSQL.

6 - Install the dependencies.

```bash
  npm install
```

7 - Start the server.

```bash
  nodemone resto.js
```
8 - Open the release:
 -   **Windows**: Change the url in developer settings to "http://localhost:3000".
 -  **Android**: Change the url in developer settings to your computer's IP on your local network "http://192.168.***.***:3000" (Hint: you can find your IP by typing 'ipconfig' in the command prompt, also make sure that your firewall allows NodeJS to connect to private and public networks or turn it off momentarily to try this project).

9 - Enjoy :D
