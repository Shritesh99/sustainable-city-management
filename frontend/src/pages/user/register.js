import * as React from "react";
import Avatar from "@mui/material/Avatar";
import Button from "@mui/material/Button";
import CssBaseline from "@mui/material/CssBaseline";
import TextField from "@mui/material/TextField";
import FormControlLabel from "@mui/material/FormControlLabel";
import Checkbox from "@mui/material/Checkbox";
import Link from "@mui/material/Link";
import Grid from "@mui/material/Grid";
import Box from "@mui/material/Box";
// import LockOutlinedIcon from '@mui/icons-material/LockOutlined';
import Typography from "@mui/material/Typography";
import Container from "@mui/material/Container";
import { createTheme, ThemeProvider } from "@mui/material/styles";
import PersonIcon from "@mui/icons-material/Person";
import List from "@mui/material/List";
import ListItem from "@mui/material/ListItem";
import ListItemText from "@mui/material/ListItemText";
import MenuItem from "@mui/material/MenuItem";
import Menu from "@mui/material/Menu";
import { userService } from "../../services";
import { useForm } from 'react-hook-form';
import { useRouter } from "next/router";

const theme = createTheme();

const options = [
  "City Manager",
  "Bike Company",
  "Bus Company",
  "Bin Truck Company",
];

const roleMap = {
  "City Manager": 1,
  "Bike Company": 2,
  "Bus Company": 3,
  "Bin Truck Company": 4
}

export default function SignUp() {
  const router = useRouter();
  const [anchorEl, setAnchorEl] = React.useState(null);
  const [selectedIndex, setSelectedIndex] = React.useState(0);
  // default value is city manager
  const [selectedRole, setSelectedRole] = React.useState("City Manager");
    // get functions to build form with useForm() hook
  const { setError, formState } = useForm();
  const { errors } = formState;

  const open = Boolean(anchorEl);
  const handleClickListItem = (event) => {
    setAnchorEl(event.currentTarget);
  };

  const handleMenuItemClick = (event, index) => {
    
    const selectedText = event.currentTarget.outerText;
    console.log({"select roleText": selectedText, "mapId": roleMap[selectedText]}); //
    setSelectedRole(selectedText);
    setSelectedIndex(index);
    setAnchorEl(null);
  };

  const handleClose = () => {
    setAnchorEl(null);
  };

  const handleSubmit = async (event) => {
    event.preventDefault();
    const formData = new FormData(event.currentTarget);
    const firstName = formData.get("firstName");
    const lastName = formData.get("lastName");
    const email = formData.get("email");
    const password = formData.get("password");

    var roleId = roleMap[selectedRole];
  
    console.log({
      firstName: formData.get("firstName"),
      lastName: formData.get("lastName"),
      email: formData.get("email"),
      password: formData.get("password"),
      roleId: roleId,
    });

    if (firstName === "" || lastName === "" || email === "" || password === "") {
      setError("registerError", { message: "Incomplete registration information" });
    } else {
      userService
        .register(firstName, lastName, email, password, roleId)
        .then(() => {
          // goto login
          router.push("/user/login");
        })
        .catch((error) => {
          console.log({"registerError" : error.message})
          setError("registerError", { message: error });
        });
    }
    
  };

  return (
    <ThemeProvider theme={theme}>
      <Container component="main" maxWidth="xs">
        <CssBaseline />
        <Box
          sx={{
            marginTop: 8,
            display: "flex",
            flexDirection: "column",
            alignItems: "center",
          }}
        >
          <Avatar sx={{ m: 1, bgcolor: "secondary.main" }}>
            <PersonIcon />
          </Avatar>
          <Typography component="h1" variant="h5">
            Sign up
          </Typography>
          <Box
            component="form"
            noValidate
            onSubmit={handleSubmit}
            sx={{ mt: 3 }}
          >
            <Grid container spacing={2}>
              <Grid item xs={12} sm={6}>
                <TextField
                  autoComplete="given-name"
                  name="firstName"
                  required
                  fullWidth
                  id="firstName"
                  label="First Name"
                  autoFocus
                />
              </Grid>
              <Grid item xs={12} sm={6}>
                <TextField
                  required
                  fullWidth
                  id="lastName"
                  label="Last Name"
                  name="lastName"
                  autoComplete="family-name"
                />
              </Grid>
              <Grid item xs={12}>
                <TextField
                  required
                  fullWidth
                  id="email"
                  label="Email Address"
                  name="email"
                  autoComplete="email"
                />
              </Grid>
              <Grid item xs={12}>
                <TextField
                  required
                  fullWidth
                  name="password"
                  label="Password"
                  type="password"
                  id="password"
                  autoComplete="new-password"
                />
              </Grid>
              <Grid item xs={12}>
                <div>
                  <List
                    component="nav"
                    aria-label="role-list"
                    sx={{ bgcolor: "background.paper" }}
                  >
                    <ListItem sx={{ backgroundColor: "rgb(238,245,250)" }}
                      button
                      id="lock-button"
                      aria-haspopup="listbox"
                      aria-controls="lock-menu"
                      aria-label="Select your role"
                      aria-expanded={open ? "true" : undefined}
                      onClick={handleClickListItem}
                    >
                      <ListItemText
                        primary="Select your role"
                        secondary={options[selectedIndex]}
                      />
                    </ListItem>
                  </List>
                  <Menu
                    id="lock-menu"
                    anchorEl={anchorEl}
                    open={open}
                    onClose={handleClose}
                    MenuListProps={{
                      "aria-labelledby": "lock-button",
                      role: "listbox",
                    }}
                  >
                    {options.map((option, index) => (
                      <MenuItem
                        key={option}
                        disabled={index === selectedIndex}
                        selected={index === selectedIndex}
                        onClick={(event) => handleMenuItemClick(event, index)}
                      >
                        {option}
                      </MenuItem>
                    ))}
                  </Menu>
                </div>
              </Grid>
            </Grid>
            {errors.registerError &&
                <div className="alert alert-danger mt-3 mb-0"><h6 style={{ color: 'red' }}>{errors.registerError?.message}</h6>
                </div>
            }
            <Button
              type="submit"
              fullWidth
              variant="contained"
              sx={{ mt: 3, mb: 2 }}
            >
              Sign Up
            </Button>
            <Grid container justifyContent="flex-end">
              <Grid item>
                <Link href="/user/login" variant="body2">
                  Already have an account? Sign in
                </Link>
              </Grid>
            </Grid>
          </Box>
        </Box>
      </Container>
    </ThemeProvider>
  );
}
