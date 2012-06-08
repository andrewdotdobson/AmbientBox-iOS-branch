package assets
{
	import tonfall.format.wav.WAVDecoder;
	/**
	 * @author Andre Michelle
	 */
	public final class AmbientLoops
	{
		
		//mine!
		[Embed(source = "../../assets/audio/1-drone.wav", mimeType = "application/octet-stream")]
			private static const LOOP1_CLASS: Class;
		
		public static const LOOP1:WAVDecoder = new WAVDecoder(new LOOP1_CLASS()); 
		
		[Embed(source = "../../assets/audio/2-basswash.wav", mimeType = "application/octet-stream")]
			private static const LOOP2_CLASS: Class;
		
		public static const LOOP2:WAVDecoder = new WAVDecoder(new LOOP2_CLASS()); 
		
		[Embed(source = "../../assets/audio/3-chime1.wav", mimeType = "application/octet-stream")]
			private static const LOOP3_CLASS: Class;
		
		public static const LOOP3:WAVDecoder = new WAVDecoder(new LOOP3_CLASS()); 
		
		[Embed(source = "../../assets/audio/4-bellz.wav", mimeType = "application/octet-stream")]
			private static const LOOP4_CLASS: Class;
		
		public static const LOOP4:WAVDecoder = new WAVDecoder(new LOOP4_CLASS()); 
		
		[Embed(source = "../../assets/audio/5-long pads.wav", mimeType = "application/octet-stream")]
			private static const LOOP5_CLASS: Class;
		
		public static const LOOP5:WAVDecoder = new WAVDecoder(new LOOP5_CLASS()); 
		
		[Embed(source = "../../assets/audio/6-bell riff.wav", mimeType = "application/octet-stream")]
			private static const LOOP6_CLASS: Class;
		
		public static const LOOP6:WAVDecoder = new WAVDecoder(new LOOP6_CLASS()); 
		
		[Embed(source = "../../assets/audio/7-long phrase.wav", mimeType = "application/octet-stream")]
			private static const LOOP7_CLASS: Class;
		
		public static const LOOP7:WAVDecoder = new WAVDecoder(new LOOP7_CLASS()); 
		
		[Embed(source = "../../assets/audio/7-long phrase.wav", mimeType = "application/octet-stream")]
			private static const LOOP8_CLASS: Class;
		
		public static const LOOP8:WAVDecoder = new WAVDecoder(new LOOP8_CLASS()); 
		
	
		
		
		
		
	}
}