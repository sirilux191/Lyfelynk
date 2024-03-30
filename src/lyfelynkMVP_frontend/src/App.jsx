import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import FirstPageContent from './onboarding/FirstPage';
import RegisterPage1Content from './onboarding/RegisterPage/RegisterPage1';
import RegisterPage2Content from './onboarding/RegisterPage/RegisterPage2';
import RegisterPage3Content from './onboarding/RegisterPage/RegisterPage3';
import NotFound from './NotFound';
import { ThemeProvider } from './components/theme-provider';
import RegisteredContent1 from './onboarding/RegisteredPage/RegisteredPage1';
import RegisteredContent2 from './onboarding/RegisteredPage/RegisteredPage2';
import RegisteredContent3 from './onboarding/RegisteredPage/RegisteredPage3';
import AppRoute1 from './Health-User/AppRoute';
import AppRoute2 from './Health-Professional/AppRoute';
import AppRoute3 from './Health-Service/AppRoute';


export default function App() {
  return (
    <ThemeProvider>
      <Router>
        <Routes>
          <Route path="/" element={<Navigate to="/Register" />} />
          <Route path="/Register" element={<FirstPageContent/>} />
          <Route path="/Register">
            <Route path="Health-User" element={<RegisterPage1Content/>} />
            <Route path="Health-User/verify" element={<RegisteredContent1/>} />

            <Route path="Health-Professional" element={<RegisterPage2Content/>} />
            <Route path="Health-Professional/verify" element={<RegisteredContent2/>} />

            <Route path="Health-Service" element={<RegisterPage3Content/>} />
            <Route path="Health-Service/verify" element={<RegisteredContent3/>} />
          </Route>

          <Route path="/Health-User/*" element={<AppRoute1/>} />
          <Route path="/Health-Professional/*" element={<AppRoute2/>} />
          <Route path="/Health-Service/*" element={<AppRoute3/>} />

          <Route path="*" element={<NotFound/>} />
        </Routes>
      </Router>
    </ThemeProvider>
  );
}


