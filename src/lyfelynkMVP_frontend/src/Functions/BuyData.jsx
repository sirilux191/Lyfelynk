import React from "react";
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
import { toast } from "@/components/ui/use-toast";
import { ShoppingCart } from "lucide-react";
import { useState } from "react";
import { useCanister } from "@connect2ic/react";
export function BuyDataFunc({ listingID, seller }) {
  const [open, setOpen] = useState(false); // Managing dialog's open state

  const [lyfelynkMVP_backend] = useCanister("lyfelynkMVP_backend");

  const handleConfirmPurchase = async () => {
    console.log(listingID);
    console.log(seller);
    try {
      const result = await lyfelynkMVP_backend.purchaseListing(
        listingID,
        seller
      );
      if (result.ok) {
        //alert("Purchase successful:", result.ok);
        toast({
          title: "Purchase successful",
          description: "Your purchase has been completed.",
          variant: "success",
        });
        setOpen(false); //dialog closes
      } else {
        //alert("Purchase failed:", result.err);
        toast({
          title: "Purchase Failed",
          description: `Error: ${result.err}`,
          variant: "destructive",
        });
      }
    } catch (error) {
      //alert("Error purchasing listing:", error);
      toast({
        title: "Error",
        description: `An error occurred: ${error}`,
        variant: "default",
      });
    }
  };

  return (
    <Dialog
      open={open}
      onOpenChange={setOpen}
    >
      <DialogTrigger asChild>
        <Button
          className="p-2 text-white"
          onClick={() => setOpen(true)}
        >
          <ShoppingCart />
        </Button>
      </DialogTrigger>
      <DialogContent className="sm:max-w-[425px]">
        <DialogHeader>
          <DialogTitle>Confirm Purchase</DialogTitle>
          <DialogDescription>
            Are you sure you want to buy this data?
          </DialogDescription>
        </DialogHeader>
        <DialogFooter>
          <Button onClick={handleConfirmPurchase}>Yes</Button>
          <DialogClose asChild>
            <Button variant="secondary">Close</Button>
          </DialogClose>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
