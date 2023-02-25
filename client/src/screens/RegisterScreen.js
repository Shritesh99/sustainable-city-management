import React, { useContext, useRef, useState } from "react";
import {
  MaterialIcons,
  Text,
  Stack,
  Pressable,
  Input,
  Box,
  Link,
  Button,
  NativeBaseProvider,
  VStack,
  Center,
  Heading,
  FormControl,
  HStack,
  Select,
  CheckIcon,
  AlertDialog,
} from "native-base";

import { AuthContext } from "../context/AuthContext";

export const RegisterScreen = ({ navigation }) => {
  const [first_name, setFirstname] = useState(null);
  const [last_name, setLastname] = useState(null);
  const [username, setUsername] = useState(null);
  const [password, setPassword] = useState(null);
  const [role_id, setRoleid] = useState("");
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [isOpen, setIsOpen] = React.useState(false);

  const onClose = () => setIsOpen(false);

  const cancelRef = React.useRef(null);
  const { isLoading, register } = useContext(AuthContext); //Get from AuthoContext

  const roleMap = [
    {
      name: "City Manager",
      key: "1",
    },
    { name: "Bus Company", key: "2" },
  ];

  return (
    <Center w="100%">
      <Box safeArea w="90%" maxW="290">
        <Heading
          size="lg"
          color="coolGray.800"
          _dark={{
            color: "warmGray.50",
          }}
          fontWeight="semibold"
        >
          Welcome
        </Heading>

        <VStack space={3} mt="1">
          <FormControl>
            <FormControl.Label>FirstName</FormControl.Label>
            <Input
              value={first_name}
              placeholder="Enter first name"
              onChangeText={(text) => setFirstname(text)}
            />
          </FormControl>
          <FormControl>
            <FormControl.Label>LastName</FormControl.Label>
            <Input
              value={last_name}
              placeholder="Enter last name"
              onChangeText={(text) => setLastname(text)}
            />
          </FormControl>
          <FormControl>
            <FormControl.Label>Email</FormControl.Label>
            <Input
              value={username}
              placeholder="Enter email"
              onChangeText={(text) => setUsername(text)}
            />
          </FormControl>
          <FormControl>
            <FormControl.Label>Password</FormControl.Label>
            <Input
              type="password"
              value={password}
              placeholder="Enter password"
              onChangeText={(text) => setPassword(text)}
              secureTextEntry
            />
          </FormControl>
          <FormControl>
            <FormControl.Label>Confirm Password</FormControl.Label>
            <Input type="password" />
          </FormControl>
          <Box maxW="300">
            <Select
              selectedValue={role_id}
              minWidth="200"
              accessibilityLabel="Choose Service"
              placeholder="Choose Service"
              _selectedItem={{
                bg: "teal.600",
                endIcon: <CheckIcon size="3" />,
              }}
              mt={1}
              onValueChange={(itemValue) => setRoleid(itemValue)}
            >
              <Select.Item label="UX Research" value="1" />
              <Select.Item label="Web Development" value="web" />
              <Select.Item label="Cross Platform Development" value="cross" />
              <Select.Item label="UI Designing" value="ui" />
              <Select.Item label="Backend Development" value="backend" />
            </Select>
          </Box>
          <Button
            mt="2"
            colorScheme="indigo"
            title="Register"
            onPress={() => {
              register(first_name, last_name, username, password, role_id),
                navigation.navigate("LoginScreen");
            }}
          >
            Sign up
          </Button>
        </VStack>
      </Box>
    </Center>
  );
};
