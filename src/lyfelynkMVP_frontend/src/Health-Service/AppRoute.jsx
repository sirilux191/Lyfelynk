import React from 'react';
import { Routes, Route } from 'react-router-dom';
import Navbar from './Navbar';
import DashboardContent from './Pages/Dashboard';
import MyHealthContent from './Pages/Records';
import MarketplaceContent from './Pages/Marketplace';
import ProfileContent from './Pages/Profile';
import ShareContent from './sub/SharePage';
import UploadContent from './sub/UploadPage';
import NotFoundPage from './NotFoundPage';
import AppBanner from '../AppBanner';

export default function AppRoute3() {
  return (
    <div>
      <Navbar/>
      <AppBanner/>
      <div class="circlePosition w-11/12 h-11/12 bg-[#367ed142] rounded-[100%] absolute -z-10 blur-[100px] flex justify-center items-center">
        <div class="circle w-[17rem] h-[17rem] bg-[#5743ee42] rounded-[100%]" />
      </div>
      <Routes>
        <Route path="/Home" element={<DashboardContent/>} />
        <Route path="/Records" element={<MyHealthContent/>} />
        <Route path="/Records">
          <Route path="/Records/Share" element={<ShareContent/>} />
          <Route path="/Records/Upload" element={<UploadContent/>} />
        </Route>
        <Route path="/Marketplace" element={<MarketplaceContent/>} />
        <Route path="/Profile" element={<ProfileContent/>} />

        <Route path="/*" element={<NotFoundPage/>} />
      </Routes>
    </div>
  );
}
