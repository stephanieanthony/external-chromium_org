// Copyright (c) 2012 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#ifndef WEBKIT_BLOB_FILE_STREAM_READER_H_
#define WEBKIT_BLOB_FILE_STREAM_READER_H_

#include "base/basictypes.h"
#include "base/compiler_specific.h"
#include "net/base/completion_callback.h"
#include "webkit/browser/webkit_storage_browser_export.h"

namespace net {
class IOBuffer;
}

namespace webkit_blob {

// A generic interface for reading a file-like object.
class WEBKIT_STORAGE_BROWSER_EXPORT FileStreamReader {
 public:
  // It is valid to delete the reader at any time.  If the stream is deleted
  // while it has a pending read, its callback will not be called.
  virtual ~FileStreamReader() {}

  // Reads from the current cursor position asynchronously.
  //
  // Up to buf_len bytes will be copied into buf.  (In other words, partial
  // reads are allowed.)  Returns the number of bytes copied, 0 if at
  // end-of-file, or an error code if the operation could not be performed.
  // If the read could not complete synchronously, then ERR_IO_PENDING is
  // returned, and the callback will be run on the thread where Read()
  // was called, when the read has completed.
  //
  // It is invalid to call Read while there is an in-flight Read operation.
  //
  // If the stream is deleted while it has an in-flight Read operation
  // |callback| will not be called.
  virtual int Read(net::IOBuffer* buf, int buf_len,
                   const net::CompletionCallback& callback) = 0;

  // Returns the length of the file if it could successfully retrieve the
  // file info *and* its last modification time equals to
  // expected modification time (rv >= 0 cases).
  // Otherwise, a negative error code is returned (rv < 0 cases).
  // If the stream is deleted while it has an in-flight GetLength operation
  // |callback| will not be called.
  // Note that the return type is int64 to return a larger file's size (a file
  // larger than 2G) but an error code should fit in the int range (may be
  // smaller than int64 range).
  virtual int64 GetLength(const net::Int64CompletionCallback& callback) = 0;
};

}  // namespace webkit_blob

#endif  // WEBKIT_BLOB_FILE_STREAM_READER_H_
