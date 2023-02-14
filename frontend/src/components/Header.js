import { getTheme, tokens } from "@/theme";
import { Typography, Box } from "@mui/material";
import Link from "next/link";
// export const Header = () => (
//   <div className="hero-head">
//     <header className="navbar has-background-primary">
//       <div className="container">
//         <div className="navbar-brand">
//           <Link
//             href="/"
//             shallow={true}
//             className="navbar-item has-text-primary-light"
//           >
//             <p className="is-size-3">Sustinable City Management</p>
//           </Link>
//         </div>
//       </div>
//     </header>
//   </div>
// );

const Header = ({ title, subtitle }) => {
  const colors = tokens();
  return (
    <Box mb="30px">
      <Typography
        variant="h2"
        color={colors.grey[100]}
        fontWeight="bold"
        sx={{ m: "0 0 5px 0" }}
      >
        {title}
      </Typography>
      <Typography variant="h5" color={colors.greenAccent[400]}>
        {subtitle}
      </Typography>
    </Box>
  );
};

export default Header;
