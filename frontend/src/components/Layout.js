import { Head } from "./Head";
import Sidebar from "./global/Sidebar";
import Topbar from "./global/Topbar";
import { getTheme } from "@/theme";
import Footer from "./global/Footer";
import styles from "./layout.module.css";
import { CssBaseline, ThemeProvider } from "@mui/material";

export const Layout = ({ children }) => {
  const theme = getTheme();
  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <div className="app">
        <Head />
        <Sidebar />
        <main className="content">
          <Topbar />
          {children}
        </main>
        <Footer />
      </div>
    </ThemeProvider>
  );
};
