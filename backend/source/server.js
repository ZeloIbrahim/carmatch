const express = require("express");
const cors = require("cors");
const voituresRouter = require("./route/voitures");

const app = express();
const PORT = process.env.port || 3000;

app.use(cors());
app.use(express.json());

app.get("/", (req,res) => {res.json({message : " CarMath API"})});
app.use ("/api/voitures", voituresRouter);
app.listen(PORT, ()=> {console.log(`CarMatch API lancee sur https://localhost:${PORT}`);});