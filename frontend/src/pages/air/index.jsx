import React from "react";
import MainMap from "../../components/air/mainMap";
import { ToastContainer } from "../../components/air/toast";
import { Box } from "@mui/material";

// import { Box } from "@chakra-ui/react";
// import { ChakraProvider } from "@chakra-ui/react";
// import { ToastContainer, _ } from "../../components/air/toast";

// export default function Air() {
//   return (
//     <RecoilRoot>
//       <ChakraProvider>
//         <Box>
//           <UtilityPanel />
//           <ToastContainer />
//           <MainMap />
//         </Box>
//       </ChakraProvider>
//     </RecoilRoot>
//   );
// }

export default function Air() {
  return (
    <Box>
      <ToastContainer />
      <MainMap />
    </Box>
  );
}
