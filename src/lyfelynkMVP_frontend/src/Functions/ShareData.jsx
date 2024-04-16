import React, { useState, useEffect } from "react";
import { useCanister } from "@connect2ic/react";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
  DialogClose,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";

export function ShareDataFunc({ assetID }) {
  const [userId, setUserId] = useState("");
  const [open, setOpen] = useState(false); // Managing dialog's open state

  const [lyfelynkMVP_backend] = useCanister("lyfelynkMVP_backend");

  const handleShare = async () => {
    try {
      const result = await lyfelynkMVP_backend.grantDataAccess(userId, assetID);
      if (result.ok) {
        alert("Access granted successfully");
        setOpen(false); //dialog closes
      } else {
        alert("Error granting access: " + result.err);
      }
    } catch (error) {
      console.error("Error granting access:", error);
    }
  };

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger asChild>
        <Button variant="outline" onClick={() => setOpen(true)}>Share</Button>
      </DialogTrigger>
      <DialogContent className="sm:max-w-[425px]">
        <DialogHeader>
          <DialogTitle>Share your data</DialogTitle>
          <DialogDescription>
            Enter the user ID you want to share your data with. Click share when
            you're done.
          </DialogDescription>
        </DialogHeader>
        <div className="grid gap-4 py-4">
          <div className="grid grid-cols-4 items-center gap-4">
            <Label
              htmlFor="userId"
              className="text-right"
            >
              User ID
            </Label>
            <Input
              id="userId"
              value={userId}
              onChange={(e) => setUserId(e.target.value)}
              className="col-span-3"
            />
          </div>
        </div>
        <DialogFooter>
          <Button onClick={handleShare}>Send</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
