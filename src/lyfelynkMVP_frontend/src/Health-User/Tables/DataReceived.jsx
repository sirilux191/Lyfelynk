import React, { useState } from "react";
import { Button } from "@/components/ui/button";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { DropdownMenu, DropdownMenuContent, DropdownMenuTrigger } from "@/components/ui/dropdown-menu";
import { Input } from "@/components/ui/input";
import { ChevronDown } from "lucide-react";
import DownloadFile from "@/Functions/DownloadFile";

const initialData = [
  { id: "file1", name: "Document 1", owner: "John Doe" },
  { id: "file2", name: "Document 2", owner: "Jane Smith" },
  { id: "file3", name: "Document 3", owner: "Alice Johnson" },
];

export function DataReceivedTable() {
  const [filter, setFilter] = useState("");

  const columns = [
    {
      accessorKey: "name",
      header: "Name",
      cell: ({ row }) => <div className="capitalize">{row.getValue("name")}</div>,
    },
    {
      accessorKey: "owner",
      header: "Owner",
      cell: ({ row }) => <div className="capitalize">{row.getValue("owner")}</div>,
    },
    {
      id: "download",
      header: "",
      cell: () => (
        <DownloadFile/>
      ),
      enableSorting: false,
      enableHiding: false,
    },
  ];

  const filteredData = initialData.filter(item =>
    item.name.toLowerCase().includes(filter.toLowerCase()) ||
    item.owner.toLowerCase().includes(filter.toLowerCase())
  );

  return (
    <div>
      <div className="flex items-center py-4">
        <Input
          placeholder="Filter Names..."
          value={filter}
          onChange={(e) => setFilter(e.target.value)}
          className="w-full mr-2"
        />
        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <Button variant="outline" className="ml-auto">
              Columns <ChevronDown className="ml-2 h-4 w-4" />
            </Button>
          </DropdownMenuTrigger>
          <DropdownMenuContent align="end">
            {columns.map(column => (
              <div key={column.accessorKey} className="capitalize">
                <input
                  type="checkbox"
                  id={column.accessorKey}
                  checked={true} // Adjust this to handle column visibility
                  // onChange={handleColumnVisibilityChange}
                />
                <label htmlFor={column.accessorKey}>{column.header}</label>
              </div>
            ))}
          </DropdownMenuContent>
        </DropdownMenu>
      </div>
      <div className="rounded-md border">
        <Table>
          <TableHeader>
            <TableRow>
              {columns.map(column => (
                <TableHead key={column.accessorKey}>{column.header}</TableHead>
              ))}
            </TableRow>
          </TableHeader>
          <TableBody>
            {filteredData.length ? (
              filteredData.map(item => (
                <TableRow key={item.id}>
                  {columns.map(column => (
                    <TableCell key={column.accessorKey}>
                      {column.cell({ row: { getValue: key => item[key] } })}
                    </TableCell>
                  ))}
                </TableRow>
              ))
            ) : (
              <TableRow>
                <TableCell colSpan={columns.length} className="h-24 text-center">
                  No results.
                </TableCell>
              </TableRow>
            )}
          </TableBody>
        </Table>
      </div>
    </div>
  );
}
