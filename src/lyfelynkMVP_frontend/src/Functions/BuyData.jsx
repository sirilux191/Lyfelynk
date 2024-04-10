import React from 'react';
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
  DialogClose
} from "@/components/ui/dialog";
import { ShoppingCart } from 'lucide-react';

export function BuyDataFunc() {
  const handleConfirmPurchase = () => {
    // Handle purchase confirmation logic here
    console.log('Confirmed purchase');
  };

  return (
    <Dialog>
      <DialogTrigger asChild>
        <Button className="p-2 text-white"> <ShoppingCart/> </Button>
      </DialogTrigger>
      <DialogContent className="sm:max-w-[425px]">
        <DialogHeader>
          <DialogTitle>Confirm Purchase</DialogTitle>
          <DialogDescription>
            Are you sure you want to buy this data?
          </DialogDescription>
        </DialogHeader>
        <DialogFooter>
          <DialogClose asChild>
            <Button onClick={handleConfirmPurchase}>Yes</Button>
          </DialogClose>

          <DialogClose asChild>
            <Button variant="secondary">Close</Button>
          </DialogClose>

        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}
