json.array!(@vmimages) do |vmimage|
  json.extract! vmimage, :id, :osname, :osversion
  json.url vmimage_url(vmimage, format: :json)
end
