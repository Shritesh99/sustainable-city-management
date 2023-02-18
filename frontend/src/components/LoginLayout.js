import { Head } from "./Head";
import Topbar from "./global/Topbar";
import { getTheme } from "@/theme";
import Footer from "./global/Footer";
import { CssBaseline, ThemeProvider } from "@mui/material";

export const LoginLayout = ({ children }) => {
  const theme = getTheme();
  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <div className="app">
        <Head />
        <main className="content">
          {children}
        </main>
        <Footer />
      </div>
    </ThemeProvider>
  );
};
