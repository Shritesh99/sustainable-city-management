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
import Typography from "@mui/material/Typography";
import Container from "@mui/material/Container";
import { createTheme, ThemeProvider } from "@mui/material/styles";
import PersonIcon from "@mui/icons-material/Person";
import { useEffect } from "react";
import { useRouter } from "next/router";
import { userService } from "../../services";
import { useForm } from 'react-hook-form';

const theme = createTheme();

export default function LoginPage() {
  const router = useRouter();

  useEffect(() => {
    // redirect to home if already logged in
    if (userService.userValue) {
      router.push("/");
    }
  }, []);

  // form validation rules
  // const validationSchema = Yup.object().shape({
  //   username: Yup.string().required("Username is required"),
  //   password: Yup.string().required("Password is required"),
  // });
  // const formOptions = { resolver: yupResolver(validationSchema) };

  // get functions to build form with useForm() hook
  const { setError, formState } = useForm();
  const { errors } = formState;

//   function onSubmit({ username, password }) {
//     return userService
//       .login(username, password)
//       .then(() => {
//         // get return url from query parameters or default to '/'
//         const returnUrl = router.query.returnUrl || "/";
//         router.push(returnUrl);
//       })
//       .catch((error) => {
//         setError("apiError", { message: error });
//       });
//   }

  const handleSubmit = async (event) => {
    event.preventDefault();

    const formData = new FormData(event.currentTarget);
    const username = formData.get("username");
    const password = formData.get("password");

    // const data = {
    //   username: formData.get("username"),
    //   password: formData.get("password"),
    // };

    console.log({
      username: username,
      password: password,
    });

    userService
      .login(username, password)
      .then(() => {
        // get return url from query parameters or default to '/'
        const returnUrl = router.query.returnUrl || "/";
        router.push(returnUrl);
      })
      .catch((error) => {
        setError("apiError", { message: error });
      });

    // Send the data to the server in JSON format.
    // const JSONdata = JSON.stringify(data);

    // API endpoint where we send form data.
    // const endpoint = "http://127.0.0.1:8080/login";

    // Form the request for sending data to the server.
    // const options = {
    //   // The method is POST because we are sending data.
    //   method: "POST",
    //   // Tell the server we're sending JSON.
    //   headers: {
    //     "Content-Type": "application/json",
    //   },
    //   // Body of the request is the JSON data we created above.
    //   body: JSONdata,
    // };

    // // Send the form data to our forms API on Vercel and get a response.
    // const response = await fetch(endpoint, options);

    // // Get the response data from server as JSON.
    // // If server returns the name submitted, that means the form works.
    // const status = response.status();

    // if (status === 200) {
    //   const result = response.json();
    //   alert(`Login Success: ${result.data}`);

    //   // get return url from query parameters or default to '/'
    //   const returnUrl = router.query.returnUrl || "/";
    //   router.push(returnUrl);
    // } else {
    //   alert(`apiError: ${result.data}`);
    // }
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
            Sign in
          </Typography>
          <Box
            component="form"
            onSubmit={handleSubmit}
            noValidate
            sx={{ mt: 1 }}
          >
            <TextField
              margin="normal"
              required
              fullWidth
              id="username"
              label="Email Address"
              name="username"
              autoComplete="email"
              autoFocus
            />
            <TextField
              margin="normal"
              required
              fullWidth
              name="password"
              label="Password"
              type="password"
              id="password"
              autoComplete="current-password"
            />
            {/* <FormControlLabel
              control={<Checkbox value="remember" color="primary" />}
              label="Remember me"
            /> */}
            <Button
              type="submit"
              fullWidth
              variant="contained"
              sx={{ mt: 3, mb: 2 }}
            >
              Sign In
            </Button>
            <Grid container>
              {/* <Grid item xs>
                <Link href="/user/forgot-password" variant="body2">
                  Forgot password?
                </Link>
              </Grid> */}
              <Grid item>
                <Link href="/user/register" variant="body2">
                  {"Don't have an account? Sign Up"}
                </Link>
              </Grid>
            </Grid>
            {/* {errors.apiError &&
                <div className="alert alert-danger mt-3 mb-0">{errors.apiError?.message}</div>
            } */}
          </Box>
        </Box>
      </Container>
    </ThemeProvider>
  );
}
