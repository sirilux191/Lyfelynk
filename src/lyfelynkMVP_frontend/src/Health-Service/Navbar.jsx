import React, { useState } from "react";
import { NavLink } from "react-router-dom";
import { Heart, LayoutDashboard, Menu, ShoppingCart, User } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Avatar, AvatarImage, AvatarFallback } from "@/components/ui/avatar";
import { ModeToggle } from "@/components/mode-toggle";
import { ConnectButton, ConnectDialog } from "@connect2ic/react";
import "../connect2ic/connect2ic.css";

const Navbar = () => {
  const [isMenuOpen, setIsMenuOpen] = useState(false);

  const handleMenuClick = () => {
    setIsMenuOpen(!isMenuOpen);
  };

  const handleLinkClick = () => {
    setIsMenuOpen(false);
  };

  return (
    <nav className="sticky top-0 z-50 w-full bg-background border-b border-muted">
      <div className="flex justify-between items-center py-4 px-8">
        <div className="flex items-center space-x-4">
          <div className="md:hidden">
            <button
              className="p-2 border rounded-lg"
              onClick={handleMenuClick}
            >
              <Menu className="h-6 w-6" />
            </button>
          </div>
          <img
            alt="Logo"
            className="h-6 w-6 md:hidden"
            src="/assets/LyfeLynk.png"
          />
          <img
            alt="Logo"
            className="h-8 w-44 hidden md:block"
            src="/assets/lyfelynk.png"
          />
          <ModeToggle />
        </div>

        <div className={`md:hidden fixed top-16 left-0 w-full bg-background border-b shadow-sm ${isMenuOpen ? "block" : "hidden"}`}>
          <div className="flex flex-col justify-center items-center h-full">
            {[
              { to: "/Health-Service/Home", icon: <LayoutDashboard />, text: "Dashboard" },
              { to: "/Health-Service/MyHealth", icon: <Heart />, text: "My Health" },
              { to: "/Health-Service/Marketplace", icon: <ShoppingCart />, text: "Marketplace" },
              { to: "/Health-Service/Profile", icon: <User />, text: "Profile" }
            ].map((link, index) => (
              <NavLink
                key={index}
                onClick={handleLinkClick}
                style={({ isActive }) => ({
                  color: isActive ? "blue" : "inherit"
                })}
                to={link.to}
                className="text-foreground hover:text-primary my-2 text-xl font-bold flex items-center"
              >
                {link.icon}
                {link.text}
              </NavLink>
            ))}
          </div>
        </div>

        <div className="hidden md:flex items-center space-x-12">
          {[
            { to: "/Health-Service/Home", icon: <LayoutDashboard />, text: "Dashboard" },
            { to: "/Health-Service/MyHealth", icon: <Heart />, text: "My Health" },
            { to: "/Health-Service/Marketplace", icon: <ShoppingCart />, text: "Marketplace" },
            { to: "/Health-Service/Profile", icon: <User />, text: "Profile" }
          ].map((link, index) => (
            <NavLink
              key={index}
              onClick={handleLinkClick}
              style={({ isActive }) => ({
                color: isActive ? "blue" : "inherit"
              })}
              to={link.to}
              className="text-foreground hover:text-primary my-2 text-xl font-bold flex items-center"
            >
              {link.icon}
              {link.text}
            </NavLink>
          ))}
        </div>

        <div className="flex items-center">
          <Avatar className="mx-4">
            <AvatarImage
              alt="John Lennon"
              src="/placeholder.svg?height=32&width=32"
            />
            <AvatarFallback>JL</AvatarFallback>
          </Avatar>
          <div className="auth-section">
            <ConnectButton />
          </div>
          <ConnectDialog />
        </div>
      </div>
    </nav>
  );
};

export default Navbar;
