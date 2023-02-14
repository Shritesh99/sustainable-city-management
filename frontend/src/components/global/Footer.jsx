import Typography from "@mui/material/Typography";
import MuiLink from "@mui/material/Link";
import Paper from "@mui/material/Paper";
import Box from "@mui/material/Box";

const Footer = () => {
  return (
    <Paper
      sx={{
        marginTop: "calc(10% + 60px)",
        width: "100%",
        position: "fixed",
        bottom: 0,
        width: "100%",
      }}
      evaluation={0}
      component="footer"
    >
      <Box
        sx={{
          flexGrow: 1,
          justifyContent: "center",
          display: "flex",
          mb: 1,
        }}
      >
        <Copyright />
      </Box>
    </Paper>
  );
};

const Copyright = () => {
  return (
    <Typography variant="body2" color="text.secondary" align="center">
      {"Copyright © "}
      <MuiLink color="inherit" href="http://localhost:3000/">
        Sustainable-City-Management
      </MuiLink>{" "}
      {new Date().getFullYear()}.
    </Typography>
  );
};

export default Footer;
