//---------------------------------------------------------------------------------------
// <copyright file="ValuesToTextConverter.cs" company="Jonathan Mathews Software">
//     ASCII Generator dotNET - Image to ASCII Art Conversion Program
//     Copyright (C) 2011 Jonathan Mathews Software. All rights reserved.
// </copyright>
// <author>Jonathan Mathews</author>
// <email>info@jmsoftware.co.uk</email>
// <email>jmsoftware@gmail.com</email>
// <website>http://www.jmsoftware.co.uk/</website>
// <website>http://ascgen2.sourceforge.net/</website>
// <license>
//    This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the license, or
//    (at your option) any later version.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see http://www.gnu.org/licenses/.
// </license>
//---------------------------------------------------------------------------------------
namespace TxtImg.AsciiConversion
{
    /// <summary>
    /// Abstract class for all values to text conversions
    /// </summary>
    public abstract class ValuesToTextConverter
    {
        #region�Public�methods

        /// <summary>
        /// Convert 2d array of byte values into character strings
        /// </summary>
        /// <param name="values">2d array of values that represent the image</param>
        /// <returns>Array of strings containing the text image</returns>
        public abstract string[] Apply(byte[][] values);

        #endregion�Public�methods
    }
}