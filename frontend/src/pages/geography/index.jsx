import { getTheme, tokens } from "@/theme";
import { Box } from "@mui/system";
import Header from "../../components/Header";
import Map from "../../components/Map";

const Geography = () => {
  const colors = tokens();
  return (
    <Box m="20px">
      <Header title="Map" subtitle="" />
      <Box height="75vh" border={`1px solid ${colors.grey}`} borderRadius="4px">
        <Map />
      </Box>
    </Box>
  );
};

export default Geography;
