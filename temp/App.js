import React, { useState, useEffect } from "react";

import "react-toastify/dist/ReactToastify.css";
import { QueryClient, QueryClientProvider } from "react-query";

import { ptBR } from "@material-ui/core/locale";
import { createTheme, ThemeProvider } from "@material-ui/core/styles";
import { useMediaQuery } from "@material-ui/core";
import ColorModeContext from "./layout/themeContext";
import { SocketContext, SocketManager } from './context/Socket/SocketContext';

import Routes from "./routes";

const queryClient = new QueryClient();

const App = () => {
    const [locale, setLocale] = useState();

    const prefersDarkMode = useMediaQuery("(prefers-color-scheme: dark)");
    const preferredTheme = window.localStorage.getItem("preferredTheme");
    const [mode, setMode] = useState(preferredTheme ? preferredTheme : prefersDarkMode ? "dark" : "light");

    const colorMode = React.useMemo(
        () => ({
            toggleColorMode: () => {
                setMode((prevMode) => (prevMode === "light" ? "dark" : "light"));
            },
        }),
        []
    );

    const theme = createTheme(
        {
            scrollbarStyles: {
                "&::-webkit-scrollbar": {
                    width: '8px',
                    height: '8px',
                },
                "&::-webkit-scrollbar-thumb": {
                    boxShadow: 'inset 0 0 6px rgba(0, 0, 0, 0.3)',
                    backgroundColor: "#128C7E",
                },
            },
            scrollbarStylesSoft: {
                "&::-webkit-scrollbar": {
                    width: "8px",
                },
                "&::-webkit-scrollbar-thumb": {
                    backgroundColor: mode === "light" ? "#C8C7C2" : "#537474",
                },
            },
            palette: {
                type: mode,
                primary: { main: mode === "light" ? "#128C7E" : "#FFFFFF" },
                textPrimary: mode === "light" ? "#128C7E" : "#FFFFFF",
                borderPrimary: mode === "light" ? "#128C7E" : "#FFFFFF",
                dark: { main: mode === "light" ? "#201F1F" : "#C8C7C2" },
                light: { main: mode === "light" ? "#F3F3F3" : "#537474" },
                tabHeaderBackground: mode === "light" ? "#EEE" : "#666",
                optionsBackground: mode === "light" ? "#fafafa" : "#201F1F",
				options: mode === "light" ? "#fafafa" : "#666",
				fontecor: mode === "light" ? "#537474" : "#fff",
                fancyBackground: mode === "light" ? "#fafafa" : "#201F1F",
				bordabox: mode === "light" ? "#eee" : "#201F1F",
				newmessagebox: mode === "light" ? "#eee" : "#201F1F",
				inputdigita: mode === "light" ? "#fff" : "#666",
				contactdrawer: mode === "light" ? "#fff" : "#666",
				announcements: mode === "light" ? "#ededed" : "#201F1F",
				login: mode === "light" ? "#fff" : "#201F1F",
				announcementspopover: mode === "light" ? "#fff" : "#666",
				chatlist: mode === "light" ? "#eee" : "#666",
				boxlist: mode === "light" ? "#ededed" : "#666",
				boxchatlist: mode === "light" ? "#ededed" : "#201F1F",
                total: mode === "light" ? "#fff" : "#201F1F",
                messageIcons: mode === "light" ? "grey" : "#F3F3F3",
                inputBackground: mode === "light" ? "#FFFFFF" : "#201F1F",
                barraSuperior: mode === "light" ? "linear-gradient(to right, #537474, #537480 , #537492)" : "#666",
				boxticket: mode === "light" ? "#EEE" : "#666",
				campaigntab: mode === "light" ? "#ededed" : "#666",
				mediainput: mode === "light" ? "#ededed" : "#201F1F",
            },
            mode,
        },
        locale
    );

    useEffect(() => {
        const i18nlocale = localStorage.getItem("i18nextLng");
        const browserLocale =
            i18nlocale.substring(0, 2) + i18nlocale.substring(3, 5);

        if (browserLocale === "ptBR") {
            setLocale(ptBR);
        }
    }, []);

    useEffect(() => {
        window.localStorage.setItem("preferredTheme", mode);
    }, [mode]);



    return (
        <ColorModeContext.Provider value={{ colorMode }}>
            <ThemeProvider theme={theme}>
                <QueryClientProvider client={queryClient}>
                  <SocketContext.Provider value={SocketManager}>
                      <Routes />
                  </SocketContext.Provider>
                </QueryClientProvider>
            </ThemeProvider>
        </ColorModeContext.Provider>
    );
};

export default App;
