package assets
{
	import tonfall.format.wav.WAVDecoder;
	/**
	 * @author Andre Michelle
	 */
	public final class AmbientLoopsLite
	{
		
		//mine!
		[Embed(source = "../../assets/audio/lite/1-drone-8.wav", mimeType = "application/octet-stream")]
			private static const LOOP1_CLASS: Class;
		
		public static const LOOP1:WAVDecoder = new WAVDecoder(new LOOP1_CLASS()); 
		
		[Embed(source = "../../assets/audio/lite/2-bass-6.wav", mimeType = "application/octet-stream")]
			private static const LOOP2_CLASS: Class;
		
		public static const LOOP2:WAVDecoder = new WAVDecoder(new LOOP2_CLASS()); 
		
		[Embed(source = "../../assets/audio/lite/3chine-2.wav", mimeType = "application/octet-stream")]
			private static const LOOP3_CLASS: Class;
		
		public static const LOOP3:WAVDecoder = new WAVDecoder(new LOOP3_CLASS()); 
		
		[Embed(source = "../../assets/audio/lite/4bells_2.wav", mimeType = "application/octet-stream")]
			private static const LOOP4_CLASS: Class;
		
		public static const LOOP4:WAVDecoder = new WAVDecoder(new LOOP4_CLASS()); 
		
		[Embed(source = "../../assets/audio/lite/5pads_8.wav", mimeType = "application/octet-stream")]
			private static const LOOP5_CLASS: Class;
		
		public static const LOOP5:WAVDecoder = new WAVDecoder(new LOOP5_CLASS()); 
		
		[Embed(source = "../../assets/audio/lite/6bellriff_2.wav", mimeType = "application/octet-stream")]
			private static const LOOP6_CLASS: Class;
		
		public static const LOOP6:WAVDecoder = new WAVDecoder(new LOOP6_CLASS()); 
		
		[Embed(source = "../../assets/audio/lite/7long_14.wav", mimeType = "application/octet-stream")]
			private static const LOOP7_CLASS: Class;
		
		public static const LOOP7:WAVDecoder = new WAVDecoder(new LOOP7_CLASS()); 
		
		[Embed(source = "../../assets/audio/lite/8beatsnu_2.wav", mimeType = "application/octet-stream")]
			private static const LOOP8_CLASS: Class;
		
		public static const LOOP8:WAVDecoder = new WAVDecoder(new LOOP8_CLASS()); 

		
		
		
	}
}