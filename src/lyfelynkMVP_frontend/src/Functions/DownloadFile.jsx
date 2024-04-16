import React from "react";
import { Button } from "@/components/ui/button";
import { Download } from "lucide-react";

const DownloadFile = ({ data, format, title }) => {
  function downloadData(file) {
    const url = URL.createObjectURL(file);
    const link = document.createElement("a");
    link.href = url;
    link.download = file.name;
    link.click();
    URL.revokeObjectURL(url);
  }

  const downloadFile = async () => {
    const retrievedFileBlob = new Blob([new Uint8Array(data)], {
      type: format,
    });
    const retrievedFile = new File([retrievedFileBlob], title, {
      type: format,
    });
    downloadData(retrievedFile);
  };

  return (
    <Button
      className="p-2 text-white"
      onClick={downloadFile}
    >
      <Download/>
    </Button>
  );
};

export default DownloadFile;
