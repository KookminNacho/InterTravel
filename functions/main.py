# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`

from firebase_functions import https_fn
from firebase_admin import initialize_app

# initialize_app()
#
#
# @https_fn.on_request()
# def on_request_example(req: https_fn.Request) -> https_fn.Response:
#     return https_fn.Response("Hello world!")

# Exit if this is triggered on a file that is not an image.
if not content_type or not content_type.startswith("image/"):
    print(f"This is not an image. ({content_type})")
    return

# Exit if the image is already a thumbnail.
if file_path.name.startswith("thumb_"):
    print("Already a thumbnail.")
    return

@storage_fn.on_object_finalized()
def generatethumbnail(event: storage_fn.CloudEvent[storage_fn.StorageObjectData]):
    """When an image is uploaded in the Storage bucket, generate a thumbnail
    automatically using Pillow."""

    bucket_name = event.data.bucket
    file_path = pathlib.PurePath(event.data.name)
    content_type = event.data.content_type

    # Exit if this is triggered on a file that is not an image.
    if not content_type or not content_type.startswith("image/"):
        print(f"This is not an image. ({content_type})")
        return

    # Exit if the image is already a thumbnail.
    if file_path.name.startswith("thumb_"):
        print("Already a thumbnail.")
        return

    bucket = storage.bucket(bucket_name)

    image_blob = bucket.blob(str(file_path))
    image_bytes = image_blob.download_as_bytes()
    image = Image.open(io.BytesIO(image_bytes))

    image.thumbnail((200, 200))
    thumbnail_io = io.BytesIO()
    image.save(thumbnail_io, format="png")
    thumbnail_path = file_path.parent / pathlib.PurePath(f"thumb_{file_path.stem}.png")
    thumbnail_blob = bucket.blob(str(thumbnail_path))
    thumbnail_blob.upload_from_string(thumbnail_io.getvalue(), content_type="image/png")