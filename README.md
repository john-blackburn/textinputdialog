# textinputdialog
Gideros Lua class to provide TextInputDialogs for WinRT.

We have not implemented a native version of TextInputDialog for WinRT since it is difficult to access complex native widgets in a WinRT DirectX app. (AlertDialog is provided using a native widget)

To implement TextInputDialog in your Gideros project and ensure it will also work in WinRT, add these Lua files and resources to your project then add the following lines at the beginning of your Lua code:

<pre>
local os = application:getDeviceInfo()

-- If the OS is WinRT then use lua class TextInputDialog2 as TextInputDialog
if os == "WinRT" then
  TextInputDialog=TextInputDialog2
end
</pre>

After this, the rest of the Lua code remains the same and TextInputDialogs will operate correctly in all operating systems. For Windows Phone, a soft keyboard will pop up (drawn manually by Lua). On Windows Store, it will use the physical keyboard. Currently only numbers, letters and spaces are implemented for the physical keyboard. An attempt has been made to match the appearance of Windows Metro style.

See main.lua for and example of how to use this library.

# Acknowledgement

I have used the InputKeyboard class, kindly provided by Mathz Franz:

https://github.com/mathz/InputKeyboard

