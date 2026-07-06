// sert à ouvrir la connexion 
// à la base de données SQLite et à la rendre 
// disponible dans toute ton application.


const path = require("path");
const { DatabaseSync } = require("node:sqlite");

const DB_PATH = path.join(__dirname,"..","db","carmatch.sqlite");
const db = new DatabaseSync(DB_PATH);

module.exports = db;